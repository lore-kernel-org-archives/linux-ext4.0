From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 21:51:24 +0200
Message-ID: <20120930195124.GF18169@1wt.eu>
References: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349034499-4731-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 30, 2012 at 03:48:19PM -0400, Theodore Ts'o wrote:
> Commits 41c4d25f78c0 and 41c4d25f78c0 introduced a regression

you mistakenly wrote the same commit ID twice.

Regards,
Willy

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
