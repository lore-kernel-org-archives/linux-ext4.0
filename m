From: "Tejas Sumant" <tejas.sumant@gmail.com>
Subject: Re: Couple of queries related to htree directory
Date: Mon, 18 Jun 2007 14:43:00 +0530
Message-ID: <ffa0f8300706180213v2814542dped06e9410f3068a9@mail.gmail.com>
References: <ffa0f8300706140622j104ad6d7ra3abb2c8779dece@mail.gmail.com>
	 <20070614184630.GB14911@thunk.org>
	 <ffa0f8300706150400u39c31a13l2805f4d8217eb4cf@mail.gmail.com>
	 <20070615163248.GE14911@thunk.org>
	 <ffa0f8300706171915y73e10f9bvf9c936b1985975d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:9324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbXFRJNB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jun 2007 05:13:01 -0400
Received: by an-out-0708.google.com with SMTP id d31so317841and
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2007 02:13:00 -0700 (PDT)
In-Reply-To: <ffa0f8300706171915y73e10f9bvf9c936b1985975d5@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Yes the lsattr found a directory with htree structure for me.

Thanks a lot!!!

On 6/18/07, Tejas Sumant <tejas.sumant@gmail.com> wrote:
> Ok. I will try lsattr. I willl let you know outcome.
>
> Thanks
>
>
> On 6/15/07, Theodore Tso <tytso@mit.edu> wrote:
> > On Fri, Jun 15, 2007 at 04:30:02PM +0530, Tejas Sumant wrote:
> > > Hi Theodore,
> > >
> > > My file system has dir_index feature.
> > > When I created new directory larger than blocksize and run htree
> > > command of debugfs on it, I received message that the directory is not
> > > in htree format.
> >
> > Can you run the debugfs stat command on the directory and send me the
> > output?
> >
> > Thanks,
> >
> >                                                 - Ted
> >
>
>
> --
> Tejas Sumant
>


-- 
Tejas Sumant
