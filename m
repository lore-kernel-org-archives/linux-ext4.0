From: Josh Hunt <johunt@akamai.com>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Mon, 28 Feb 2011 12:17:55 -0800
Message-ID: <4D6C02F3.7070209@akamai.com>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com> <20110224063749.GV22723@ZenIV.linux.org.uk> <20110224112010.GB23042@quack.suse.cz> <4D66BD18.2030207@akamai.com> <20110228175734.GC20805@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110228175734.GC20805@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/28/2011 09:57 AM, Jan Kara wrote:
> On Thu 24-02-11 12:18:32, Josh Hunt wrote:
>> On 02/24/2011 03:20 AM, Jan Kara wrote:
>>> On Thu 24-02-11 06:37:49, Al Viro wrote:
>>>> On Wed, Feb 23, 2011 at 10:21:41PM -0800, Josh Hunt wrote:
>>>>> [resending: left Jan off the original mail by accident]
>>>>>
>>>>> We have a multi-threaded workload which is currently "losing" files in the form
>>>>> of unattached inodes. The workload is link, rename, unlink intensive. This is
>>>>> happening on an ext2 filesystem and have reproduced the issue in kernel
>>>>> 2.6.37.  Here's a sample strace:
>>>>>
>>>>>     open("/a/tmp/tmpfile.1296184058", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 9
>>>>>     link("/a/tmp/tmpfile.1296184058", "/a/tmp/tmpfile.28117.1296184059") = 0
>>>>>     rename("/a/tmp/tmpfile.28117.1296184059", "/a/tmp/tmpfile") = 0
>>>>>     stat64("/a/tmp/tmpfile", {st_mode=S_IFREG|0644, st_size=24248267, ...}) = 0
>>>>>     link("/a/tmp/tmpfile", "/a/tmp/submit/tmpfile")        = 0
>>>>>     open("/a/tmp/tmpfile.1296184058", O_RDONLY) = 13
>>>>>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDWR|O_CREAT|O_EXCL, 0600) = 824
>>>>>     rename("/a/tmp/submit/tmpfile", "/a/tmp/submit/tmpfile.send.q9SNoL")                = 0
>>>>>     unlink("/a/tmp/tmpfile.1296184058") = 0
>>>>>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 827
>>>>>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 828
>>>>>     open("/a/tmp/submit/tmpfile.send.q9SNoL", O_RDONLY) = 829
>>>>>     unlink("/a/tmp/submit/tmpfile.send.q9SNoL") = 0
>>>>>
>>>>> The application behavior shown above repeats indefinitely with most filenames
>>>>> changing during each iteration except for 'tmpfile'. Looking into this issue I
>>>>> see that vfs_rename_other() only takes i_mutex for the new inode and the new
>>>>> inode's directory as well as the old directory's mutex. This works for
>>>>> modifying the dir entry and appears to be fine for most filesystems, but
>>>>> ext2 and a few others (exofs, minix, nilfs2, omfs, sysv, ufs) modify i_nlink
>>>>> inside of their respective rename functions without grabbing the i_mutex. The
>>>>> modifications are done through calls to inode_inc_link_count(old_inode) and
>>>>> inode_dec_link_count(old_inode), etc.
>>>>>
>>>>> Taking the mutex for the old inode appears to resolve the issue of the
>>>>> lost files/unattached inodes that I am seeing with this workload. I've attached
>>>>> a patch below doing what I've described above. If this is an accepted solution
>>>>> I believe other filesystems may also be affected by this and I could provide
>>>>> a patch for those as well.
>>>>
>>>> I don't know...  The thing is, we mostly do that to make life easier for
>>>> fsck in case of crash.  Other than that, there's no reason to play with
>>>> link count of that sucker at all.  The question is, do we really want
>>>> such rename() interrupted by dirty shutdown to result in what looks like two
>>>> legitimate links to that inode without any indications of what had happened?
>>>> Note that fsck (at least on ext2) will correct link counts anyway and if
>>>> nothing else, we probably want some noise pointing to the inode in question...
>>>   Yeah, I agree that playing with the link count is not worth it. It is
>>> even more disputable because it would have some reasonable effect only if
>>> we happened to write out the moved inode after it is linked to the new
>>> directory and before it is unlinked from the old one. Moreover we'd need
>>> to writeout the new directory and not the old directory before crash
>>> happens. All this is highly unlikely and even if that happens, it is
>>> questionable whether the result is worth it. So I'll just do away with
>>> those games with link count...
>>>   The patch is attached. Josh, can you test it as well? Thanks.
>>>
>>> 								Honza
>> Jan
>>
>> I'm not seeing the problem with your patch as was expected since we're
>> not messing with i_nlink anymore. Al suggested marking the inode as
>> dirty where we were previously doing the old_inode dec. I believe this
>> is needed as well since we are updating it's ctime. I've attached a
>> version marking the inode dirty and it also fixes the comment making
>> reference to calling inode_dec_link_count().
>   Yeah, good catch. Thanks.
> 
>> I'm not completely clear on the historical reasons for messing with the
>> link count of old_inode in the first place. It was just to simulate the
>> linking and unlinking of the old_inode?
>   Yes.
> 
> So I took your patch and used a changelog from mine as I find it more
> descriptive. The resulting patch is in my tree (and attached).
> 
> 								Honza
Jan

Thanks. We should probably send this to the stable guys as well.

I've found the same issue with a few other filesystems. I'll bundle up
those patches and send out a set in the coming days along with an easily
reproducible testcase.

Josh
