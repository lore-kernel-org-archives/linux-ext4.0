From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Mon, 24 Jun 2013 15:48:14 +0900
Message-ID: <CAKYAXd-QqhuDKAm8zFTtmiovWEax-OoyEixuQKSWxF2zQVXFSQ@mail.gmail.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
	<03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2013/6/24, Andreas Dilger <adilger@dilger.ca>:
> On 2013-06-23, at 0:07, Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch series introduces 2 new ioctls for ext4.
>>
>> Truncate_block_range ioctl truncates blocks from source file.
>
Hi. Andreas.
> How is this different from fallocate(FALLOC_FL_PUNCH_HOLE)?  That is already
> in existing kernels, and portable across multiple filesystems.
Dave chinner already answered it.

>
>> Transfer_block_range ioctl transfers data blocks from source file
>> and append them at the end of destination file.
>
> There is already a similar ioctl for defragmenting files. Is it possible to
> use that, or does it have different semantics?

For defrag ioctl:
struct move_extent {
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};

For this ioctl to work, there are some pre conditions:
1) Contiguous blocks for donor_fd are allocated in user space using fallocate.
2) orig_start and donor_start should be same.

The fundamental difference between these 2 ioctls is that in defrag
ioctl data is copied, (page by page?) from the extents of source file
to the newly allocated extents of donor file. However, in transfer
block range ioctl the extents are transfered from the source file and
appended at the end of donor file. There is only metadata movement.

Thanks.
>
>> Ioctl1:        EXT4_IOC_TRUNCATE_BLOCK_RANGE:
>> This ioctl truncates a range of data blocks from file.
>> It is useful to remove easily and quickly the garbage data
>> at the middle of file.
>>
>> e.g. we have a movie file and there is long advertisement in movie file.
>> user want to remove only advertisement range.
>
> While this works in theory, there is very little chance that the movie data
> will align exactly to filesystem block boundaries.
>
> Cheers, Andreas
>
>> 1) Movie file (8GB), There is the adverisement of 500MB size.
>> ____________________________________________________________________
