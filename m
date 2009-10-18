From: Jon Burgess <jburgess777@googlemail.com>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 18:15:05 +0100
Message-ID: <1255886105.27380.158.camel@localhost.localdomain>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
	 <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
	 <20091018114100.GA26721@eagle102.home.lan>
	 <84c89ac10910180614l5d2d476ehb91d210820761039@mail.gmail.com>
	 <1255878457.27380.138.camel@localhost.localdomain>
	 <84c89ac10910180929t2bebfd3eq26eb318475a24fd4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Matija Nalis <mnalis-ml@voyager.hr>, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46091 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZJRRPD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 13:15:03 -0400
Received: by ewy4 with SMTP id 4so829173ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 10:15:07 -0700 (PDT)
In-Reply-To: <84c89ac10910180929t2bebfd3eq26eb318475a24fd4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-10-18 at 21:59 +0530, Viji V Nair wrote:
> On Sun, Oct 18, 2009 at 8:37 PM, Jon Burgess <jburgess777@googlemail.com> wrote:
> > On Sun, 2009-10-18 at 18:44 +0530, Viji V Nair wrote:
> >> >
> >> >> can see lots of system resources are free, memory, processors etc
> >> >> (these are 4G, 2 x 5420 XEON)
> >
> > 4GB may be a little small. Have you checked whether the IO reading your
> > data sources is the bottleneck?
> 
> I will be upgrading the RAM, but I didn't see any swap usage while
> running this applications...
> the data source is on a different machine, postgres+postgis. I have
> checked the IO, looks fine. It is a 50G DB running on 16GB dual xeon
> box

Going into swap is not the issue. If you have extra RAM available then
the OS will use this as a disk cache which means the DB will be able to
access indexes etc without needing to wait for the disk every time. 16GB
of RAM for a 50GB DB should be sufficient if the data is sensibly
indexed.

> I have to give a try on mod_tile. Do you have any suggestion on using
> nginx/varnish as a cahce layer?

There have been some tests using squid as a cache in front of mod_tile.
This worked reasonably well but did not give a big performance increase
because the server was already able to handle the load without an
additional cache. If you want to discuss this further then I'd suggest
continuing the conversation on the OSM or Mapnik lists.

	Jon


