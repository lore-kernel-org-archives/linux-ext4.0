From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Subject: RE: Is it possible for the ext4/btrfs file system to pass some
 context related info to low level block driver?
Date: Wed, 4 May 2011 19:45:16 +0800
Message-ID: <CE761E84DADF2947A4AF22FB8D97A47358EE526A@shsmsx501.ccr.corp.intel.com>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
 <yq1mxj32932.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <yq1mxj32932.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>Yes, I have been working on some changes that allow us to tag bios and
>pass the information out to storage. These patches have been on the back
>burner for a while due to other commitments. But I'll dig them out and
>post them later. We just discussed them a couple of weeks ago at the
>Linux Storage Workshop.

That's great! Thanks for the update and look forward to your patches.

>In the meantime: Can you point me to the relevant eMMC stuff so I can
>see how many tiers or classes we have to work with there?
>
I'm investigating on add some eMMC 4.5 features support in current Linux mmc driver (drivers/mmc).
The Linux mmc driver register the eMMC device as a normal Linux block device. So, it can get all the Linux block layer bio flags.

To below eMMC 4.5 new features:

Data Tag:
'The mechanism permits the device to receive from the host information about specific data types (for instance file system metadata, time-stamps, configuration parameters, etc.). The information is conveyed before a write multiple blocks operation at well defined addresses. By receiving this information the device can improve the access rate during the following read and update operations and offer a more reliable and robust storage.'

I guess the exist block layer flag REQ_META can be used to notify the low level block driver/device to execute the Data Tag feature. But don't know why currently most of Linux file systems don't use the REQ_META flag at all (seems only gfs2 uses it now).

Context Management:
'To better differentiate between large sequential operations and small random operations, and to improve multitasking support, contexts can be associated with groups of read or write commands ... A context can be seen as an active session, configured for a specific read/write pattern (e.g. sequential in some granularity). Multiple read or write commands are associated with this context to create some logical association between them, to allow device to optimize performance.'

To my understanding, to support this feature, it needs file system (or application?) to notify the low level driver that the following data access will be large sequential read/write operations.
And I'm not sure is it possible for file system to pass this kind of information to low level driver? Any idea?

Thanks.

Regards,
Yunpeng




