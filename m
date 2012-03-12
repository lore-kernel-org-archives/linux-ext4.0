From: "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int
 may_flags' in nfsd_open()
Date: Mon, 12 Mar 2012 11:49:21 -0400
Message-ID: <20120312154921.GB17153@pad.fieldses.org>
References: <20120109132158.2616029.30467.stgit@localhost.localdomain>
 <20120109132153.2616029.26302.stgit@localhost.localdomain>
 <20120306000837.GA17164@thunk.org>
 <20120306020819.GH31388@pad.fieldses.org>
 <20120306151816.GB32282@thunk.org>
 <20120306152842.GA8339@pad.fieldses.org>
 <20120309205148.GB5635@thunk.org>
 <20120312150912.GB12440@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: "Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120312150912.GB12440-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 12, 2012 at 11:09:12AM -0400, Ted Ts'o wrote:
> On Fri, Mar 09, 2012 at 03:51:48PM -0500, Ted Ts'o wrote:
> > 
> > Linus in general doesn't like cross tree merges (or any extraneous
> > merges) unless they are absolutely necessary; but then, he trusts git
> > merges more than many of us do.  :-)
> > 
> > I've put the the patch series on a separate patch, with a signed tag, at:
> > 
> >      git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git nfs-ext4-premerge
> > 
> > Can you confirm that you've pulled it into your tree and it's landed
> > in linux-next?  I probably won't bother pulling it in mine unless
> > there is definitely a merge conflict that I need to resolve.  (I've
> > checked and there do not appear to be any against linux-next as of
> > last night.)
> 
> Ping?

Whoops, sorry.

Looks perfect, thanks for handling these!

I'm running them through my usual regression tests and then I'll push
the result out soon, with a "here's why I'm merging this" comment on the
merge commit.  (Though I can't see it would trigger Linus's usual
back-merge rant anyway, as it's obviously quite targetted, not a case of
"oh I think I'll update to -rc5 now".)

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
