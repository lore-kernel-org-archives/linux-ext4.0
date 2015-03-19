From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Thu, 19 Mar 2015 13:13:39 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503191313120.1399@localhost.localdomain>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com> <alpine.LFD.2.00.1503181142160.23465@localhost.localdomain> <20150318173931.GJ29195@taesoo.org> <alpine.LFD.2.00.1503191046280.29774@localhost.localdomain>
 <20150319120243.GG31460@taesoo.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1474426983-1426767224=:1399"
Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
	csong84@gatech.edu
To: Taesoo Kim <taesoo@gatech.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150319120243.GG31460@taesoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1474426983-1426767224=:1399
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 19 Mar 2015, Taesoo Kim wrote:

> Date: Thu, 19 Mar 2015 08:02:43 -0400
> From: Taesoo Kim <taesoo@gatech.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
>     csong84@gatech.edu
> Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
> 
> On 03/19/15 at 10:48am, Lukáš Czerner wrote:
> > On Wed, 18 Mar 2015, Taesoo Kim wrote:
> > 
> > > Date: Wed, 18 Mar 2015 13:39:31 -0400
> > > From: Taesoo Kim <taesoo@gatech.edu>
> > > To: Lukáš Czerner <lczerner@redhat.com>
> > > Cc: Taesoo Kim <tsgatesv@gmail.com>, tytso@mit.edu,
> > >     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> > >     changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
> > >     csong84@gatech.edu
> > > Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
> > > 
> > > > The patch looks good, thanks.
> > > 
> > > Thank you.
> > >  
> > > > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> > > > 
> > > > Btw, were you able to reproduce the problem, or have you seen the
> > > > problem in the wild ? Or did you just spot it in the code ?
> > > 
> > > We are developing a static checker to spot inconsistent programming
> > > patterns; our first goal is to scan over existing filesystems and
> > > figure out how they are implemented differently (or similarly). We
> > > will report bugs in sequence as soon as our team confirm (just start
> > > sending patches to other fs).
> > 
> > And this was found but it ?
> 
> Our current prototype.
>  
> > But anyway it sounds really interesting, do you have any more
> > information you can share about the project ? Project website,
> > description, or source code would be great :)
> 
> We need 1-2 months to wrap up. I would say, right after the deadline,
> we plan to make the code/result publicly available :)

Great! Looking forward to it.

Thanks!
-Lukas
--8323328-1474426983-1426767224=:1399--
