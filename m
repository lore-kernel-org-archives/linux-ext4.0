From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 16:02:35 +0100
Message-ID: <4580160B.1060006@bull.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net>	<m3wt4vzxje.fsf@bzzz.home.net> <45801018.1090001@bull.net> <m3odq7zw1d.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46891 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991AbWLMPEm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 10:04:42 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3odq7zw1d.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> ah, it's simple. you're looking at superblock counters.
> we don't update them every time. this was changed years
> ago. try the same with regular ext3
>=20
Yes, sorry, I didn't know that and I didn't notice that before.
And the per-group counters are right.

Thanks a lot for your clarification.
   Val=E9rie
