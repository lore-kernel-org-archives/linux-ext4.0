From: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int
 may_flags' in nfsd_open()
Date: Mon, 19 Mar 2012 20:10:28 -0400
Message-ID: <20120320001028.GA11958@thunk.org>
References: <20120313200117.GA21991@fieldses.org>
 <4F5FA827.8020606@itwm.fraunhofer.de>
 <20120313203446.GB21991@fieldses.org>
 <4F5FB771.9010805@fastmail.fm>
 <20120313212947.GK31995@pad.fieldses.org>
 <4F60AC0D.9020204@itwm.fraunhofer.de>
 <20120314160529.GB31194@fieldses.org>
 <4F63AF2B.5080307@fastmail.fm>
 <20120319025455.GD31682@thunk.org>
 <20120319200041.GA25161@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120319200041.GA25161-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 19, 2012 at 04:00:41PM -0400, J. Bruce Fields wrote:
> Sorry that was more of a hassle than it could have been....  It would be
> nice to try rewriting the cthon tests for xfstests, if that would help
> catch nfs-related bugs sooner.  I don't have the time for now, though.

No problem.  I'd love to look at adapting the connectathon tests for
xfstests as well, but I don't have the time either.

I'll put it on an ext4 todo list; maybe someone who is looking to get
into ext4 programming will take this on as a task.

     	  	      	   	     	   - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
