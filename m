From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 17:12:13 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405211711470.2114@localhost.localdomain>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com> <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain> <20140521145315.GA8868@thunk.org> <CAOkSjBgXt-Ju3q+yNM13jx2UccDspJCAPZgd=vDyYYMo_kO_BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1623464646-1400685136=:2114"
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaEUPMU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 11:12:20 -0400
In-Reply-To: <CAOkSjBgXt-Ju3q+yNM13jx2UccDspJCAPZgd=vDyYYMo_kO_BQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1623464646-1400685136=:2114
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 21 May 2014, Arturo Borrero Gonzalez wrote:

> Date: Wed, 21 May 2014 17:06:56 +0200
> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Subject: Re: OOPs in ext4
> 
> On 21 May 2014 16:53, Theodore Ts'o <tytso@mit.edu> wrote:
> > Also, after the system rebooted, what messages if any did e2fsck
> > report?
> >
> 
> Unfortunately, my e2fsck is translated to spanish. I will do my best
> to translate the report to english.

you can run:

LANG=C e2fsck -nf /dev/vda1

> 
> root@debian:~# e2fsck -nf /dev/vda1
> e2fsck 1.42.5 (29-Jul-2012)
> Warning!  /dev/vda1 is mounted.
> Warning: no repair will be done to the transactions file, given the
> check is read only.
> Step 1: Checking inodes, blocks and sizes
> Step 2: Checking dirs tree
> Step 3: Checking dirs connectivity
> Step 4: Checking refcounts
> Step 5: Checking group info
> 
> The free blocks count is incorrect (5721853, counted=5579610).
> ¿Fix? no
> 
> The free i-nodes count is incorrect (2348360, counted=2348351).
> ¿Fix? no
> 
> /dev/vda1: 273080/2621440 files (0.8% non-contiguous), 4763651/10485504 blocks
> 
> regards
> 
--8323328-1623464646-1400685136=:2114--
