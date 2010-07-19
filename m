From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 09/18] xstat: Make special system filesystems return
	FS_SPECIAL_FL [ver #6]
Date: Mon, 19 Jul 2010 15:09:33 +0100
Message-ID: <8426.1279548573@redhat.com>
References: <20100718084955.GB27794@infradead.org>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021720.5544.19973.stgit@warthog.procyon.org.uk>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100718084955.GB27794@infradead.org>
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

Christoph Hellwig <hch@infradead.org> wrote:

> special is not a very useful identifier.  Also what you are returning
> is per-filesystem data, not per-file.  This needs to go into statfs,
> not into stat.  We're about to introduce flags for statfs, so try
> to do it ontop of those.
> 
> The same thing applies to the remote flag in the next patch.

Which means that you have to do two calls (xstat+statfs) to find this
information that we can return pretty much for free here, though you can cache
it based on st_dev, I suppose.

Also, not all the flags are per-filesystem.  The following are:

	FS_SPECIAL_FL		/* Special file as found in procfs/sysfs */
	FS_REMOTE_FL		/* File is remote */

but the rest aren't:

	FS_AUTOMOUNT_FL		/* Specific automount point */
	FS_AUTOMOUNT_ANY_FL	/* Unspecific automount directory */
	FS_ENCRYPTED_FL		/* File is encrypted */
	FS_HIDDEN_FL		/* File is marked hidden (DOS+) */
	FS_SYSTEM_FL		/* File is marked system (DOS+) */
	FS_ARCHIVE_FL		/* File is marked archive (DOS+) */
	FS_TEMPORARY_FL		/* File is temporary (NTFS/CIFS) */
	FS_OFFLINE_FL		/* File is offline (CIFS) */
	FS_REPARSE_POINT_FL	/* Reparse point (NTFS/CIFS) */

David
