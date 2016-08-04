From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Thu, 4 Aug 2016 13:51:44 -0500
Message-ID: <57A38EC0.2020906@redhat.com>
References: <1470331056-796-1-git-send-email-mchristi@redhat.com>
 <20160804184602.GA3128@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	minchan@kernel.org, ngupta@vflare.org, vishal.l.verma@intel.com,
	axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160804184602.GA3128@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/04/2016 01:46 PM, Ross Zwisler wrote:
> On Thu, Aug 04, 2016 at 12:17:36PM -0500, Mike Christie wrote:
>> This fixes a regression from
>> 4e1b2d52a80d79296a5d899d73249748dea71a53
>> block, fs, drivers: remove REQ_OP compat defs and related code
>>
>> The rw_page users were not converted to use bio/req ops. As a result
>> bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
>> be sent down as reads.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
> 
> Was the intention for this to fix the xfs.mkfs hang I reported with
> generic/361 + XFS?

The hang when also using loop? If so, you also need Christoph's patches:

http://marc.info/?l=linux-fsdevel&m=147032181909530&w=2
http://marc.info/?l=linux-fsdevel&m=147031989408783&w=2

My patch just fixes rw_page users like brd.
