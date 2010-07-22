From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
	extended file stats available [ver #6]
Date: Thu, 22 Jul 2010 14:17:50 +0200
Message-ID: <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Date: Thu, 22 Jul 2010 14:17:50 +0200
Content-Disposition: inline
In-Reply-To: <30448.1279800887@redhat.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 01:14:47PM +0100, David Howells wrote:
> Jan Engelhardt <jengelh@medozas.de> wrote:
> 
> > Linux already has a creation time field, it's called otime (there is no "b"
> > in "creation"), and you will find scattered fragments of that all over the
> > kernel (foremost, fs/jfs/, now btrfs, and I also notice sysvipc having
> > something with that name).
> 
> It is?  It's called crtime in Ext4.  st_btime, however, would be compatible
> with BSD's stat, and Samba would just use it by way of autoconf magic if it
> appeared.

Samba has the following check:

# recent FreeBSD, NetBSD have creation timestamps called birthtime:             
AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec])
AC_CHECK_MEMBERS([struct stat.st_birthtime], AC_CHECK_MEMBERS([struct stat.st_birthtimensec]))

and the supporting code around that. "birth" might also be
where the "b" comes from :-)

Volker
