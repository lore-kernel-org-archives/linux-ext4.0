From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Wed, 16 May 2012 10:25:25 +0300
Message-ID: <4FB35665.5090908@panasas.com>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net> <4FAD30D7.3070208@panasas.com> <20120515091542.51f3dd78@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>,
	DOCUMENTATION <linux-doc@vger.kernel.org>
To: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120515091542.51f3dd78@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/15/2012 02:15 AM, NeilBrown wrote:

> On Fri, 11 May 2012 18:31:35 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 05/11/2012 06:49 AM, Roland Eggner wrote:
>>


Neil && Jan.

As I  said in my last mail:
	"Shared files" problem is not solved by mount options.

For me this is just a UNIX new-be 101 problem. You need to
share files with friends you make the mistake once. Then
you learn and you go on. It's a none problem.

Your removable media thing is just your "shared folder"
on a UNIX system. Deal with it. Da

Or go degrade your FS to vfat security. You are reluctant
to chmod all files to be world/group writeable but you
are doing just that with your mount option. Perhaps
when the chmod -R will scroll through you'd realize
that the passwords file you should remove. The POSIX
permissions are just for that purpose. "I set access
control at creation. Else slave to change them". The
mount option they specifically left out, not because
they were not clever, but because you don't want it.

BTW NTFS is like UNIX. If written in the right user-private
permissions you can't read them. Even admin. You can only chown
them.

BTW Neil with Kerberos auth in an NFS/CIFS shared device
like you mentioned, then a uid/gid is already associated
with the access automatically. It's a perfect IDEA for
these device makers. They need develop nothing only set it
up with the same NFS / SAMBA implementations they already
use.

And one last thing Neil. Yes an rm is a perfect rope
for an admin to hang itself, but it is not aimed at
auto-mounter scripts

I can't believe I got dragged into this again.

:-(
Boaz
