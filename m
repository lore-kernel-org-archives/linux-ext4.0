From: Solofo.Ramangalahy@bull.net
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 20:44:32 +0100
Message-ID: <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	<20081103134008.GE29102@mit.edu>
	<319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com>
	<20081103165144.6514f003@starbug.prg01.itonis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jindrich Makovicka <makovick@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50089 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYKETok (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 14:44:40 -0500
In-Reply-To: <20081103165144.6514f003@starbug.prg01.itonis.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jindrich,

Jindrich Makovicka writes:
 > The following testcase was used to trigger the infamous MAP_SHARED
 > dirty flag bug. Maybe it could be of some help here too:
 > 
 > http://lkml.org/lkml/2006/12/27/180

Thanks for remembering!

The test case triggers corruption with 2.6.28-rc3 + ext4 patch queue:
. bunch of errors like
  Chunk 71637 corrupted (0-1339)  (2756-4095)
  Expected 213, got 0
  with default mount.
. nodelalloc is ok.

-- 
solofo
