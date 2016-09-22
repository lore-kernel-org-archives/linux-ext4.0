From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4, f2fs: fscrypt_has_permitted_context() check in file open
Date: Thu, 22 Sep 2016 09:44:33 -0400
Message-ID: <20160922134433.w3riey2mhtvs54dx@thunk.org>
References: <6789d30e-f95d-d8bd-cd6e-664a89c0dfd1@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6789d30e-f95d-d8bd-cd6e-664a89c0dfd1@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 02:24:35PM +0200, Richard Weinberger wrote:
> Hi!
> 
> Both ext4 and f2fs check in the file open code the context of the parent directory too:
> 
> ext4:
>         if (ext4_encrypted_inode(d_inode(dir)) &&
>                         !fscrypt_has_permitted_context(d_inode(dir), inode)) {
>                 ext4_warning(inode->i_sb,
>                              "Inconsistent encryption contexts: %lu/%lu",
>                              (unsigned long) d_inode(dir)->i_ino,
>                              (unsigned long) inode->i_ino);
>                 dput(dir);
>                 return -EPERM;
>         }
> 
> f2fs:
>         if (f2fs_encrypted_inode(d_inode(dir)) &&
>                         !fscrypt_has_permitted_context(d_inode(dir), inode)) {
>                 dput(dir);
>                 return -EPERM;
>         }
> 
> Why do we need this check? AFAIK this situation can never happen unless due to
> a bug in the filesystem code.

Or in the case of a malicious attacker who is trying to achieve an
off-line attack on your file system....  applications aren't going to
be checking to see if they are writing their file with encryption
enabled (and with the correct key), because they will largely be
encryption oblivious.

So imagine a case where you have a file, say, dissidents.txt.  This
file is encrypted, and is in a encrypted directory.  The bad guy, in
an offline attack (e.g., using a tool like debugfs), creates a
replacement directory which is unencrypted, and creates a link to the
encrypted dissidents.txt file to that replacement directory.

You then go back to your hotel room in Beijing, boot your laptop, fire
up your editor, and then edit the dissidents.txt file.  You have the
keys, so it is read in just fine into vi or emacs.  But when when you
write out the file, the editor writes the file into
dissidents.txt.new, calls fsync on it, and then renames dissidents.txt
to dissidents.txt~, and renames dissidents.txt.new to dissidents.txt.
But since it is now in an unencrypted directory, dissidents.txt is now
unencrypted.

You then leave the hotel room, and the MSS agent goes back to your
room, and completes the exfiltration of dissidents.txt.

Cheers,

						- Ted

P.S.  If you're from China, replace MSS with FBI, and Beijing with
Washington, D.C.  :-)   The principle is the same in either case.
