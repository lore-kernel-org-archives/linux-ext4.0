From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v2] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Fri, 04 Jan 2013 11:19:42 +0800
Message-ID: <50E64A4E.7010408@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <50E646BC.2090201@asianux.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

=D3=DA 2013=C4=EA01=D4=C204=C8=D5 11:04, Chen Gang =D0=B4=B5=C0:
> +#define ACL_MAX_SHORT_ENTRY     (4)

 sorry,
   should use "4" instead of "(4)".
   I need send patch v3.




--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
