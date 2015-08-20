From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 Resend 07/10] fs: Drop unlikely before IS_ERR(_OR_NULL)
Date: Thu, 20 Aug 2015 21:44:16 +0530
Message-ID: <20150820161416.GC4159@linux>
References: <cover.1439375087.git.viresh.kumar@linaro.org>
 <2efb962cb72884f625116cba24fc4fb203c6621f.1439375087.git.viresh.kumar@linaro.org>
 <20150812142815.27968b32@tlielax.poochiereds.net>
 <CAH2r5mvUC2WO6sVqhe_QCgiCJbRbahDsSj=-Uzk7LB_peTqjLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>,
	"open list:NFS, Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Petr Vandrovec
	<petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org moderated
	list:COMMON INTERNET FILE SYSTEM CIFS, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Tom Haynes <loghyr-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Tyler Hicks
	<tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Weston Andros Adamson <dros-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>"
	<linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org,
	Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	"open list:COMMON INTERNET FILE SYSTEM CIFS"
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:ECRYPT FILE SYSTEM" <ecryptfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"open list:FILESYSTEMS VFS and infrastructure"
	<linux-fsde
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mvUC2WO6sVqhe_QCgiCJbRbahDsSj=-Uzk7LB_peTqjLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 20-08-15, 11:08, Steve French wrote:
> Reviewed-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Do you want me to merge the fs/cifs part of this independently (into
> cifs-2.6.git staging tree) or are you going to merge all of this
> (which changes multiple fs) at one time through someone else's tree?

The plan is to merge via Trivial tree, but the Maintainer isn't
responding yet :)

-- 
viresh
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
