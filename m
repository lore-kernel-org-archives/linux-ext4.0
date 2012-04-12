From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int
 may_flags' in nfsd_open()
Date: Thu, 12 Apr 2012 17:25:34 -0400
Message-ID: <20120412212534.GF6667@fieldses.org>
References: <20120312154921.GB17153@pad.fieldses.org>
 <20120312222250.GD8991@fieldses.org>
 <20120313200117.GA21991@fieldses.org>
 <4F5FA827.8020606@itwm.fraunhofer.de>
 <20120313203446.GB21991@fieldses.org>
 <4F5FB771.9010805@fastmail.fm>
 <20120313212947.GK31995@pad.fieldses.org>
 <4F60AC0D.9020204@itwm.fraunhofer.de>
 <20120412204948.GE6667@fieldses.org>
 <4F8747A1.8060800@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F8747A1.8060800-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 12, 2012 at 11:22:41PM +0200, Bernd Schubert wrote:
> On 04/12/2012 10:49 PM, J. Bruce Fields wrote:
> > Stupid question: is there any fundamental feature of ext4 this depends
> > on, or would this fix work equally well for fs/ext3?
> 
> First of all, Bruce and Ted, thanks a lot for your patience with those
> patches!
> 
> I have not looked into it in detail yet, but it should be possible to
> back port it to ext3. I don't think there is anything that would depend
> on ext4. I also have ext3 on my todo list, but I first wanted to have it
> in ext4 (in the sense of stability of ext3, if there still should be a
> bug...) and I think for 3.4 it is too late now anyways. So unless there
> are objections, lets target the back port to ext3 for 3.5?

That sounds sensible, thanks!

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
