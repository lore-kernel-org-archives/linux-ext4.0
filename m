From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Fri, 15 Jun 2012 03:40:09 -0600
Message-ID: <94C38A12-AA21-40EF-85AC-B4410F7F03B0@dilger.ca>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206142155.32009.arnd.bergmann@linaro.org> <A65DE25A-54D6-4367-9CBD-E47A36B7E4AE@dilger.ca> <201206150925.40625.arnd.bergmann@linaro.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201206150925.40625.arnd.bergmann@linaro.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2012-06-15, at 3:25 AM, Arnd Bergmann wrote:
> On Friday 15 June 2012, Andreas Dilger wrote:
>> On 2012-06-14, at 3:55 PM, Arnd Bergmann wrote:
>>> My feeling is that we would actually benefit much more from the
>>> erase block alignment than from the context for the large files.
>>> 
>>> I think this is something we can do in the Linaro storage team.
>>> We actually have plans to also put the erase block size in the swap
>>> header, so we should be able to use the same code in mke2fs and mkswap,
>>> and potentially others. What we discussed in the storage team meeting
>>> today is that we start out by making ext4 aware of the erase block
>>> size through the superblock and aligning extents for large files to
>>> erase block boundaries.
>> 
>> Note that there are already the s_raid_stride and s_raid_stripe_width,
>> used by the ext4 allocator to align the start and size of allocations
>> on RAID systems.  The erase block size would be like s_raid_stride
>> (the minimum amount of data to allocate and write contiguously).
>> 
>> I don't know that there is a benefit to having a separate erase block
>> size, since in the end it means the same as s_raid_stride to the
>> allocator - make sure allocations/writes are aligned and sized on
>> multiples of this.
> 
> Good point. For flash drives, the specific optimizations we do might
> be different from what we do on RAID, but they have enough in common
> that we could use the same mechanism to detect them.
> 
> Is ext4 able to cope well with stride sizes between 512KB and 24MB?

It is typically used on RAID arrays with 1MB or 4MB alignment.  It is
considerably more CPU efficient to use power-of-two alignment, but it
is also possible to use non-power-of-two values if needed, so long as
they are at least a multiple of the block size.

Cheers, Andreas





