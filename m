From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 00/21] Consolidate Posix ACL implementation V3
Date: Tue, 7 Jan 2014 07:53:24 -0800
Message-ID: <20140107155324.GA24113@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>,
	Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andreas Gruenbacher <andreas.gruenbacher-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131220131635.650823732-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 20, 2013 at 05:16:35AM -0800, Christoph Hellwig wrote:
> This series consolidates the various cut'n'pasted Posix ACL implementations
> into a single common one based on the ->get_acl method Linus added a while
> ago and a new ->set_acl counterpart.
> 
> This remove ~1800 lines of code and provides a single place to implement
> various nasty little gems of the semantics.

Any more comments?  Al, what's the best way to make sure this doesn't
miss 3.14?

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
