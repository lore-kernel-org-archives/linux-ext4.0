From: "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5 3/4] nfsd_open(): rename 'int access' to 'int
 may_flags' in nfsd_open()
Date: Tue, 13 Mar 2012 17:27:40 -0400
Message-ID: <20120313212740.GJ31995@pad.fieldses.org>
References: <20120306151816.GB32282@thunk.org>
 <20120306152842.GA8339@pad.fieldses.org>
 <20120309205148.GB5635@thunk.org>
 <20120312150912.GB12440@thunk.org>
 <20120312154921.GB17153@pad.fieldses.org>
 <20120312222250.GD8991@fieldses.org>
 <20120313200117.GA21991@fieldses.org>
 <4F5FA827.8020606@itwm.fraunhofer.de>
 <20120313203446.GB21991@fieldses.org>
 <20120313211009.GA11969@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yong.fan-KloliPT79xf2eFz/2MeuCQ@public.gmane.org,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org
To: "Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120313211009.GA11969-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 13, 2012 at 05:10:09PM -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 04:34:46PM -0400, J. Bruce Fields wrote:
> > > 
> > > Thanks! I'm also just going to work on it (just noticed your mail
> > > while on vacation ...).
> 
> Brend, thanks!!
> 
> Bruce, random question --- do you know what the copyright and
> licensing terms are for the connectathon test suite?

Alas.  Nobody does!

I'ts unlikely there's any owner who would care enough to make a fuss--so
we keep using the tests, but they don't really get any love.

It's one of those annoyances we argue about once a year or so, and then
forget till next time.

So, maybe one way forward would be to reimplement the connectathon tests
for xfstests?

--b.

> It occurs to me
> that it might be good to get some of these tests into xfstests, given
> that you mentioned that the telldir test was failing even when run on
> a local file system.  That says to me this is a good file system level
> test that we should try to get into xfstests if possible.
> 
> Getting it into xfstests would also tend to reduce the chance of
> regressions, since I always run xfstests before I submit patches (and
> in fact I did run xfstests before sending you a pull request Bernd's
> patches --- and I'm glad your testing caught the problem when mine
> didn't!)
> 
> Thanks,
> 
>      	       	      	       		- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
