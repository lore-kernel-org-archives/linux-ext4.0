From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] nfsd: vfs_llseek() with O_32BITHASH or O_64BITHASH
Date: Wed, 27 Jul 2011 17:03:44 -0400
Message-ID: <20110727210344.GC9066@infradead.org>
References: <20110727110148.204979.49551.stgit@localhost.localdomain>
 <20110727110259.204979.56782.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110727110259.204979.56782.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 27, 2011 at 01:02:59PM +0200, Bernd Schubert wrote:
> Use 32-bit or 64-bit llseek() hashes for directory offsets depending on
> the NFS version. NFSv2 gets 32-bit hashes only.

Independent of the O_ vs FMODE thing make sure you pass the correct
flag at open time, instead of racy runtime modifications.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
