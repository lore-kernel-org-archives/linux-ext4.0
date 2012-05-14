From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH] ext4: turn on i_version updates by default
Date: Mon, 14 May 2012 17:33:04 -0600
Message-ID: <A0359961-B147-4343-BFA3-E82F38C6700B@dilger.ca>
References: <20120514140618.GA29902@fieldses.org> <9124E59E-2479-4C32-A528-3237B48DEC01@dilger.ca> <1337036918.2522.32.camel@lade.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	"Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337036918.2522.32.camel-SyLVLa/KEI9HwK5hSS5vWB2eb7JE58TQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2012-05-14, at 5:08 PM, Myklebust, Trond wrote:
> On Mon, 2012-05-14 at 09:02 -0600, Andreas Dilger wrote:
>> On 2012-05-14, at 8:06, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
>>> knfsd needs i_version updates on, as will userspace nfs servers and
>>> probably others.
>>> 
>>> The only effects are that inode->i_version is bumped (under the i_lock)
>>> in more places, and that ->dirty_inode(I_DIRTY_DATASYNC) may be called
>>> more frequently than once per jiffy on write (see file_update_time).
>>> However the latter appears to be mostly a no-op in that case.
>> 
>> I thought this can have noticeable performance impact, since ext4_mark_inode_dirty() is quite heavyweight?
>> 
>> This is one of the reasons that the i_version update is conditional.
>> If someone is exporting a filesystem from userspace the should be
>> able to turn this on as a mount option, and knfsd could do it from inside the kernel. Why add overhead when it is not needed?
> 
> No. Having knfsd doing something like that under the covers is a BAD
> idea. It is way too easy to get into situations where someone starts
> changing files after the mount and before knfsd is started. As soon as
> you allow files to be changed without i_version changing, then you are
> setting yourself up for future corruption.
> 
> Ideally, an NFSv4-exported filesystem should be required to set the
> tune2fs mount_opts to include the 'i_version' flag to make it hard to
> inadvertently mount that filesystem without it.

I said as much in another reply - that once i_version is used on
a filesystem, it should be made "sticky" (i.e. permanently enabled
for that filesystem).  However, until that time it shouldn't be
enabled just because it might one day be used.

Even better than just blindly bumping the i_version on every change,
it would be better to have users of i_version (i.e. knfsd) flag the
inode with "needs i_version update" then read the version.  When the
filesystem/VFS bumps i_version the next time it can clear this flag
and not update i_version again until after the next time i_version
is actually used.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
