From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: [PATCH] implement uid and gid mount options for ext2, ext3 and
 ext4
Date: Wed, 25 Apr 2012 13:54:26 +0200
Message-ID: <4F97E5F2.50501@suse.de>
References: <1335281356-2943-1-git-send-email-ludwig.nussel@suse.de> <4F971936.6070809@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	"Jan Kara (maintainer:EXT2 FILE SYSTEM)" <jack@suse.cz>,
	"Andrew Morton (maintainer:EXT3 FILE SYSTEM)"
	<akpm@linux-foundation.org>,
	"Andreas Dilger (maintainer:EXT3 FILE SYSTEM)"
	<adilger.kernel@dilger.ca>,
	"\"Theodore Ts'o\" (maintainer:EXT4 FILE SYSTEM)" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4F971936.6070809@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Rob Landley wrote:
> On 04/24/2012 10:29 AM, Ludwig Nussel wrote:
>> Further development of a patch I sent years ago. I didn't find the
>> time to address the concerns raised back then and forgot about the
>> patch. Now here it is again.
>=20
> The doc bits look fine:
>=20
> Acked-by: Rob Landley <rob@landley.net>
>=20
> As for the design: why isn't this in the VFS instead of in ext234? It
> seems like VFAT is more likely to need this, and I vaguely recall vir=
tfs
> (I.E. 9pfs) doing something similar...?

Yes, file systems like FAT that do not store ownership information
themselves have a uid option. I agree that handling that in vfs itself
would be the more generic solution. It would require more work though.

cu
Ludwig

--=20
 (o_   Ludwig Nussel
 //\
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 16746 (AG N=FCrnberg)=20
