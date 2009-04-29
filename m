From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Wed, 29 Apr 2009 11:12:18 +0900 (JST)
Message-ID: <20090429110828.4B08.A69D9226@jp.fujitsu.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: kosaki.motohiro@jp.fujitsu.com, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZD2CMX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 22:12:23 -0400
In-Reply-To: <1240941840.15136.44.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi 

> Hello everyone,
> 
> I've rediffed the ext3 data=guarded code against Linus' current git
> tree, and worked in most of Jan's suggestions:

I'm not fs expert and I can't review it technically. but please don't
use the name of "guarded". this word implies strong protection. 

I think end-user can misunderstand this mode make slowness and strong protect
much than "mode=journal".



