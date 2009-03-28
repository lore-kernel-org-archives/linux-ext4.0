From: David Rees <drees76@gmail.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 17:24:54 -0700
Message-ID: <72dbd3150903271724n5e7900a5j2486707565cd9d74@mail.gmail.com>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	<1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com>
	<20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz>
	<20090327230902.GG5176@mit.edu> <49CD6BCC.6080602@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:2969 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZC1AZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 20:25:13 -0400
In-Reply-To: <49CD6BCC.6080602@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 27, 2009 at 5:14 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Theodore Tso wrote:
>> OTOH, the really big databases will tend to use direct I/O, so they
>> won't be dirtying the page cache anyway. =A0So maybe it's not worth =
the
>
> Not necessarily... =A0From what I understand, a lot of the individual
> low-level components in cloud storage, such as GoogleFS's chunk serve=
r[1] do
> not bypass the page cache, even though they do care about the details=
 of
> data caching and data consistency.

PostgreSQL does not use direct I/O, either (except for the
write-ahead-logs which are written sequentially and only get read
during database recovery).  I'm sure that most of MySQL's database
engines, also don't.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
