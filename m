From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Wed, 04 Jul 2007 12:54:18 +0530
Message-ID: <468B4B22.7040605@linux.vnet.ibm.com>
References: <1183275416.4010.125.camel@localhost.localdomain> <1183458506.4102.5.camel@garfield.linsyssoft.com> <1183519975.3922.7.camel@localhost.localdomain> <468B3FDA.7060809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, Kalpak Shah <kalpak@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758039AbXGDHZP@vger.kernel.org>
In-Reply-To: <468B3FDA.7060809@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> 
> 
> Mingming Cao wrote:
>> On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
>>> On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
>>>> +
>>>> +#define EXT4_INODE_GET_XTIME(xtime, inode, 
>>>> raw_inode)                   \
>>>> +do {                                           \
>>>> +    (inode)->xtime.tv_sec = 
>>>> le32_to_cpu((raw_inode)->xtime);           \
>>>> +    if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## 
>>>> _extra))     \
>>>> +        ext4_decode_extra_time(&(inode)->xtime,                   \
>>>> +                       raw_inode->xtime ## _extra);           \
>>>> +} while (0)
>>>> +
>>>> +#define EXT4_EINODE_GET_XTIME(xtime, einode, 
>>>> raw_inode)                   \
>>>> +do {                                           \
>>>> +    if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))               \
>>>> +        (einode)->xtime.tv_sec = 
>>>> le32_to_cpu((raw_inode)->xtime);      \
>>>> +    if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## 
>>>> _extra))           \
>>>> +        ext4_decode_extra_time(&(einode)->xtime,               \
>>>> +                       raw_inode->xtime ## _extra);           \
>>>> +} while (0)
>>>> +
>>> This nanosecond patch seems to be missing the fix below which is 
>>> required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
>>>
>>> If the timestamp is set to before epoch i.e. a negative timestamp 
>>> then the file may have its date set into the future on 64-bit 
>>> systems. So when the timestamp is read it must be cast as signed.
>>
>> Missed this one.
>> Thanks. Will update ext4 patch queue tonight with this fix.
>>
>>
> 
> 
> IIRC in the conference call it was decided to not to apply this patch. 
> Andreas may be able to update better.
> 


Looking at the git log i understand the core patch got applied to ext4 tree with the comment
from Andreas. So may be we can apply this patch also.


commit 4d7bf11d649c72621ca31b8ea12b9c94af380e63

Andreas says:
    
    This patch is now treating timestamps with the high bit set as negative
    times (before Jan 1, 1970).  This means we lose 1/2 of the possible range
    of timestamps (lopping off 68 years before unix timestamp overflow -
    now only 30 years away :-) to handle the extremely rare case of setting
    timestamps into the distant past.
    
    If we are only interested in fixing the underflow case, we could just
    limit the values to 0 instead of storing negative values.  At worst this
    will skew the timestamp by a few hours for timezones in the far east
    (files would still show Jan 1, 1970 in "ls -l" output).
    
    That said, it seems 32-bit systems (mine at least) allow files to be set
    into the past (01/01/1907 works fine) so it seems this patch is bringing
    the x86_64 behaviour into sync with other kernels.
    
    On the plus side, we have a patch that is ready to add nanosecond timestamps
    to ext3 and as an added bonus adds 2 high bits to the on-disk timestamp so
    this extends the maximum date to 2242.
    
NOTE: The conference call i mentioned above is http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call


-aneesh
