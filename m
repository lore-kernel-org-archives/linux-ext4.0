From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Wed, 04 Jul 2007 12:06:10 +0530
Message-ID: <468B3FDA.7060809@linux.vnet.ibm.com>
References: <1183275416.4010.125.camel@localhost.localdomain> <1183458506.4102.5.camel@garfield.linsyssoft.com> <1183519975.3922.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kalpak Shah <kalpak@clusterfs.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183519975.3922.7.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
>> On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
>>> +
>>> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
>>> +do {									       \
>>> +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
>>> +		ext4_decode_extra_time(&(inode)->xtime,			       \
>>> +				       raw_inode->xtime ## _extra);	       \
>>> +} while (0)
>>> +
>>> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
>>> +do {									       \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
>>> +		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
>>> +		ext4_decode_extra_time(&(einode)->xtime,		       \
>>> +				       raw_inode->xtime ## _extra);	       \
>>> +} while (0)
>>> +
>> This nanosecond patch seems to be missing the fix below which is required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
>>
>> If the timestamp is set to before epoch i.e. a negative timestamp then the file may have its date set into the future on 64-bit systems. So when the timestamp is read it must be cast as signed.
> 
> Missed this one.
> Thanks. Will update ext4 patch queue tonight with this fix.
> 
>


IIRC in the conference call it was decided to not to apply this patch. Andreas may be able to update better.

-aneesh
