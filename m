From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 21:39:39 +0200
Message-ID: <8739lksjus.fsf@rho.meyering.net>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <878vvcspz0.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>,
	coreutils-mXXj517/zsQ@public.gmane.org, Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>,
	xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <878vvcspz0.fsf-CybKA8TIZ99x3y/oJEDuiw@public.gmane.org> (Jim Meyering's message of
	"Thu, 14 Apr 2011 19:27:31 +0200")
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Jim Meyering wrote:
...
> FYI, I see the same failure now using ext3 (and but not w/ext4)
> with rawhide's 2.6.39-0.rc2.git0.0.fc16.x86_64:

Correction.
The failure below is not on ext3, but on a loopback-mounted
ext4 file system.

The test detected that the current FS was ext3 -- and it's known
that this test is not useful on ext3 -- and since I was running it
as root, it creates a loopback ext4 file system on which to run the test.

>   + df -t ext3 .
>   + require_root_
>   + uid_is_privileged_
>   ++ id -u
>   + my_uid=0

However, other strange things are happening here.
I'm investigating.
