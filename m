From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Is it possible for the ext4/btrfs file system to pass some context related info to low level block driver?
Date: Wed, 4 May 2011 08:51:39 -0600
Message-ID: <60C31100-5694-4CA9-A778-91CB15915052@dilger.ca>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com> <yq1mxj32932.fsf@sermon.lab.mkp.net> <CE761E84DADF2947A4AF22FB8D97A47358EE526A@shsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A47358EE526A@shsmsx501.ccr.corp.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-05-04, at 5:45 AM, "Gao, Yunpeng" <yunpeng.gao@intel.com> wrote:
>> Yes, I have been working on some changes that allow us to tag bios and
>> pass the information out to storage. These patches have been on the back
>> burner for a while due to other commitments. But I'll dig them out and
>> post them later. We just discussed them a couple of weeks ago at the
>> Linux Storage Workshop.
> 
> That's great! Thanks for the update and look forward to your patches.
> 
>> In the meantime: Can you point me to the relevant eMMC stuff so I can
>> see how many tiers or classes we have to work with there?
>> 
> I'm investigating on add some eMMC 4.5 features support in current Linux mmc driver (drivers/mmc).
> The Linux mmc driver register the eMMC device as a normal Linux block device. So, it can get all the Linux block layer bio flags.
> 
> To below eMMC 4.5 new features:
> 
> Data Tag:
> 'The mechanism permits the device to receive from the host information about specific data types (for instance file system metadata, time-stamps, configuration parameters, etc.). The information is conveyed before a write multiple blocks operation at well defined addresses. By receiving this information the device can improve the access rate during the following read and update operations and offer a more reliable and robust storage.'
> 
> I guess the exist block layer flag REQ_META can be used to notify the low level block driver/device to execute the Data Tag feature. But don't know why currently most of Linux file systems don't use the REQ_META flag at all (seems only gfs2 uses it now).

I was aware of REQ_META, but I didn't know there was any benefit to using it. I think it would be easy to set REQ_META on all ext4 metadata if there was a reason to do so. 

> Context Management:
> 'To better differentiate between large sequential operations and small random operations, and to improve multitasking support, contexts can be associated with groups of read or write commands ... A context can be seen as an active session, configured for a specific read/write pattern (e.g. sequential in some granularity). Multiple read or write commands are associated with this context to create some logical association between them, to allow device to optimize performance.'
> 
> To my understanding, to support this feature, it needs file system (or application?) to notify the low level driver that the following data access will be large sequential read/write operations.
> And I'm not sure is it possible for file system to pass this kind of information to low level driver? Any idea?

A simple way to do this would be to use the inode number as the context, so writes to the same inode are grouped together. Another possibility is the PID, though that is less clearly correct (e.g. if tar is extracting a buch of files, are they all related or not).

Cheers, Andreas