const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AreaCalculator", function () {
    let AreaCalculator, areaCalculator;

    before(async function () {
        AreaCalculator = await ethers.getContractFactory("AreaCalculator");
        areaCalculator = await AreaCalculator.deploy();
        // await areaCalculator.deployed();
    });

    describe("circleCalculator", function () {
        it("Should calculate the area of a circle correctly", async function () {
            const radius = 7;
            const expectedArea = Math.floor((radius * 22) / 7);
            expect(await areaCalculator.circleCalculator(radius)).to.equal(expectedArea);
        });

        it("Should revert with a negative radius", async function () {
            const radius = -7;
            await expect(areaCalculator.circleCalculator(radius)).to.be.revertedWith("Radius must be a positive integer!");
        });

        it("Should revert with zero radius", async function () {
            const radius = 0;
            await expect(areaCalculator.circleCalculator(radius)).to.be.revertedWith("Radius must be a positive integer!");
        });
    });

    describe("triangleCalculator", function () {
        it("Should calculate the area of a triangle correctly", async function () {
            const base = 10;
            const height = 5;
            const expectedArea = (base * height) / 2;
            expect(await areaCalculator.triangleCalculator(base, height)).to.equal(expectedArea);
        });

        it("Should return 0 if either base or height is 0", async function () {
            const base = 0;
            const height = 5;
            expect(await areaCalculator.triangleCalculator(base, height)).to.equal(0);
        });
    });

    describe("squareCalculator", function () {
        it("Should calculate the area of a square correctly", async function () {
            const length = 5;
            const expectedArea = length ** 2;
            expect(await areaCalculator.squareCalculator(length)).to.equal(expectedArea);
        });

        it("Should return 0 if either length or breadth is 0", async function () {
            const length = 0;
            expect(await areaCalculator.squareCalculator(length)).to.equal(0);
        });
    });

    describe("rectangleCalculator", function () {
        it("Should calculate the area of a rectangle correctly", async function () {
            const length = 10;
            const breadth = 5;
            const expectedArea = length * breadth;
            expect(await areaCalculator.rectangleCalculator(length, breadth)).to.equal(expectedArea);
        });

        it("Should return 0 if either length or breadth is 0", async function () {
            const length = 0;
            const breadth = 5;
            expect(await areaCalculator.rectangleCalculator(length, breadth)).to.equal(0);
        });
    });
});
