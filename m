From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 10:33:17 +0300
Message-ID: <BANLkTinLxrarrb0W2eA-=ZM=2LbA33qiZA@mail.gmail.com>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305066574-1573-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

Can you provide a bit of a wider scope review of how this related to
the work on stable pages.
=46or example, when to the pages get unlocked?
If the pages supposed to be stable during writeback, how is this relate=
d to
returning locked pages from page_mkwrite?
Is the page going to stay locked until writeback?
Do I understand correctly that a page will be marked read-only after
writeback completes, so page_mkwrite will be called again on next write=
?

Thanks,
Amir.

On Wed, May 11, 2011 at 1:29 AM, Jan Kara <jack@suse.cz> wrote:
>
> =A0Hi,
>
> =A0following three patches reimplement ext4_page_mkwrite() so that it=
 returns
> locked pages (which is necessary for stable pages work and also for f=
ixing of
> freezing code). As a bonus we also avoid taking i_alloc_sem as it's n=
ot
> necessary and use generic block_page_mkwrite() helper. The common del=
alloc
> path should be more straightforward now.
>
> The last patch in the series blocks mmaped writes on frozen filesyste=
m which
> is simple to do now.
>
> I've tested these patches by xfstests and also running fsx-linux for =
all
> modes - delalloc, nodelalloc (data=3Dwriteback), nodelalloc (data=3Do=
rdered),
> nodelalloc (data=3Djournal).
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
