From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/6] ext4: sysfs: print ext4_super_block fields as little-endian
Date: Thu, 21 Jun 2018 22:07:14 +0200
Message-ID: <CAK8P3a3ZRZKRn=6LB6ZtRGTezKc6cC8MRcnaN-86g6Z3whXNqA@mail.gmail.com>
References: <20180620153322.54221-1-arnd@arndb.de> <4D58091B-6028-4E24-9EDD-0B4D53314FB8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Tyson Nottingham <tgnottingham@gmail.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D58091B-6028-4E24-9EDD-0B4D53314FB8@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 21, 2018 at 7:49 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Jun 20, 2018, at 9:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> While working on extended rand for last_error/first_error timestamps,
>> I noticed that the endianess is wrong, we access the little-endian
>> fields in struct ext4_super_block as native-endian when we print them.
>>
>> This adds a special case in ext4_attr_show() and ext4_attr_store()
>> to byteswap the superblock fields if needed.
>>
>> In older kernels, this code was part of super.c, it got moved to sysfs.c
>> in linux-4.4.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 52c198c6820f ("ext4: add sysfs entry showing whether the fs contains errors")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> I was wondering why this didn't just use le32_to_cpu() all the time,
> but I see that these functions are being used for both ext4_super_block
> (on-disk) fields, as well as ext4_sb_info (in-memory) fields.  A bit
> ugly, but I don't think there is a better solution.
>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

One alternative that I considered was to just do away with helpers
for the ext4_super_block structure and only use them for ext4_sb_info,
especially after the last patch that changes this again. However,
as a bugfix for stable backports it seemed best to keep the change
as simple as possible.

Thanks for the review,

      Arnd
