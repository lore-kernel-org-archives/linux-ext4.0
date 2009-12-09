From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] [RFC] vfs: add generic reserved space management
	interface
Date: Wed, 9 Dec 2009 10:00:19 -0700
Message-ID: <20091209170019.GA7246@parisc-linux.org>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org> <20091209110836.GE4863@quack.suse.de> <873a3kqjyy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <873a3kqjyy.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 09, 2009 at 05:51:17PM +0300, Dmitry Monakhov wrote:
> >From other point of view, we may change inode structure like this:
> struct quota_ptr
> {
>         struct dquot            *dquot[MAXQUOTAS];
> };
> struct quota_rsv_ptr
> {
>         struct dquot            *dquot[MAXQUOTAS];
>         qsize_t                 reservation;
> };
> struct inode {
> ....
> #ifdef CONFIG_QUOTA
>        union {
>              struct quota_ptr i_dquot;
>              struct quota_rsv_ptr i_dquot_rsv;
>        };
> #endif
> ....
> };

What's wrong with:

#ifdef CONFIG_QUOTA
	union {
		struct dquot	*i_dquot[MAXQUOTAS];
		struct quota_rsv_ptr i_dquot_rsv;
	};
#endif


voila, no changes needed.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
