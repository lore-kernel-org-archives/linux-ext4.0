From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 23:53:52 -0300
Message-ID: <20090826025352.GD14047__2951.11717791787$1251255250$gmane$org@khazad-dum.debian.net>
References: <4A9468E8.607@redhat.com>
 <20090825225114.GE4300@elf.ucw.cz>
 <4A946DD1.8090906@redhat.com>
 <20090825232601.GF4300@elf.ucw.cz>
 <4A947682.2010204@redhat.com>
 <20090825235359.GJ4300@elf.ucw.cz>
 <4A947DA9.2080906@redhat.com>
 <20090826001645.GN4300@elf.ucw.cz>
 <4A948259.40007@redhat.com>
 <20090826010018.GA17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <r
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41314 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456AbZHZCxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:53:52 -0400
Content-Disposition: inline
In-Reply-To: <20090826010018.GA17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Aug 2009, Theodore Tso wrote:
> a UPS to your system.  Provision your RAID array with hot spares, and
> regularly scrub (read-test) your array so that failed drives can be

Can we get a proper scrub function (full rewrite of all component
disks), please?  Not every disk out there will stop a streaming read to
rewrite weak sectors it happens to come across.

> detected early.  Make sure you configure your MD setup so that you get
> e-mail when a hard drive fails and the array starts running in
> degraded mode, so you can replace the failed drive ASAP.

Debian got this right :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
