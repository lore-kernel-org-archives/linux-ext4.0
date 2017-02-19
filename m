From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v3 1/5] vfs: Add file timestamp range support
Date: Sun, 19 Feb 2017 11:23:59 -0800
Message-ID: <CABeXuvoe0N=iY6ySKP8T-_Q8kFgZUV_iE8m5m5RkwzWbhdnqrQ@mail.gmail.com>
References: <1487460608-15697-1-git-send-email-deepa.kernel@gmail.com>
 <1487460608-15697-2-git-send-email-deepa.kernel@gmail.com> <20170219015638.GG29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170219015638.GG29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> @@ -257,6 +257,8 @@ struct dentry *mount_pseudo_xattr(struct file_system_type *fs_type, char *name,
>> +     s->s_time_min = TIME64_MIN;
>> +     s->s_time_max = TIME64_MAX;
>> @@ -518,6 +520,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
>> +     s->s_time_min = TIME64_MIN;
>> +     s->s_time_max = TIME64_MAX;
>> @@ -247,6 +247,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>> +     s->s_time_min = TIME64_MIN;
>> +     s->s_time_max = TIME64_MAX;
>
> If we always initialize them that way, why does libfs.c code bother
> reassign the same values?

Initially, I considered the idea of having invalid range
initialization for all super blocks:
https://patchwork.kernel.org/patch/8488641/

At that point, it made sense to override the initializations in libfs.c.

The problem with this is we will have to change all filesystems at the
same time.
So I decided to change the strategy to include valid limits so that we
don't break any filesystems
and can first merge the basic infrastructure.
But, I was hoping we could go back to invalid range eventually which
is why I left the libfs.c initializations in.

But, you are right. This is redundant for now and maybe makes sense to
leave it out.
I will post an update.

Thanks,
Deepa
