From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Thu, 22 Jul 2010 13:14:47 +0100
Message-ID: <30448.1279800887@redhat.com>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
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

Jan Engelhardt <jengelh@medozas.de> wrote:

> Linux already has a creation time field, it's called otime (there is no "b"
> in "creation"), and you will find scattered fragments of that all over the
> kernel (foremost, fs/jfs/, now btrfs, and I also notice sysvipc having
> something with that name).

It is?  It's called crtime in Ext4.  st_btime, however, would be compatible
with BSD's stat, and Samba would just use it by way of autoconf magic if it
appeared.

David
