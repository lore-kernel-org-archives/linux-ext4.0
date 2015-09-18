From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH e2fsprogs] subst: use 0644 perms
Date: Fri, 18 Sep 2015 14:36:34 -0600
Message-ID: <E6355B76-4796-4AFE-B971-CC544331DEB8@dilger.ca>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org> <E093072B-F995-496D-BE3D-B14EB5A1C27A@dilger.ca> <20150918180824.GE2213@vapier.lan>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33716 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbIRUgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2015 16:36:40 -0400
Received: by pacex6 with SMTP id ex6so59966325pac.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2015 13:36:39 -0700 (PDT)
In-Reply-To: <20150918180824.GE2213@vapier.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2015, at 12:08 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> 
> On 18 Sep 2015 10:52, Andreas Dilger wrote:
>> On Sep 18, 2015, at 01:54, Mike Frysinger <vapier@gentoo.org> wrote:
>>> When running on NFS, opening files with 0444 perms for writing can
>>> sometimes fail.  Since there's no real reason for these files to be
>>> read-only, give the owner write permission.
>> 
>> Actually, there IS a reason for subst to make these files read-only. They are auto-generated and any edits to these files can be overwritten and lost if their origin files are modified. 
>> 
>> I'd lost edits to these auto generated files many time because they are the ones that "tags" or "cscope" will jump to when searching for symbols. 
>> 
>> There really isn't any reason for them to be writable, so the fact that you are getting an error trying to open them for writing is a hint that you are doing, or going to do, the wrong thing and the read-only nature of the file is preventing you from going down the wrong path. 
> 
> I think you misread my report.  this has nothing to do with people
> trying to modify the files after the fact.  NFS can (and sometimes
> does) throw an error at the time of the *open* call even if the file
> doesn't exist.

Seems like a bug in NFS.  At least I know the POSIX test suite requires
that to work (we had similar problems with Lustre that had to be fixed many years ago).  In fact, there is a special check for this in knfsd:


nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
                                        struct dentry *dentry, int acc)
{
    :
    :

    /*
     * The file owner always gets access permission for accesses that
     * would normally be checked at open time. This is to make
     * file access work even when the client has done a fchmod(fd, 0).
     *
     * However, `cp foo bar' should fail nevertheless when bar is
     * readonly. A sensible way to do this might be to reject all
     * attempts to truncate a read-only file, because a creat() call
     * always implies file truncation.
     * ... but this isn't really fair.  A process may reasonably call
     * ftruncate on an open file descriptor on a file with perm 000.
     * We must trust the client to do permission checking - using "ACCESS"
     * with NFSv3.
     */
    if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
        uid_eq(inode->i_uid, current_fsuid()))
            return 0;
    :
    :
}

Might be something that needs to be pursued with the kernel NFS folks?
That said, I'm not against fixing subst so that it works on your system.

> if you want to try to "protect" people, then it needs to be a chmod
> after all the data has been written & closed.

It that case, please update your patch to include something like:

                        if (verbose)
                                printf("Creating or replacing %s.\n", outfn);
+                       /* Avoid accidentally editing generated file. */
+                       (void)fchmod(out, 0444);
                        fclose(out);
                        if (old)
                                fclose(old);

>  this is how it used to
> behave, but commit 2873927d15ffb9ee9ed0e2700791a0e519c715aa changed it.


Cheers, Andreas





