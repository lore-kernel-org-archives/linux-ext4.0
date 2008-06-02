From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 15:20:47 +0200
Message-ID: <4843F3AF.2010701@bull.net>
References: <48402253.8040407@bull.net> <4841A871.3020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37387 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYFBNVI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 09:21:08 -0400
In-Reply-To: <4841A871.3020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> One other question on the tests; am I reading correctly that ext3 use=
d
> "data=3Dwriteback" but ext4 used the default data=3Dordered mode?

When the delalloc patches are applied, the data=3Dwriteback mode is for=
ced.
This is why I set this mode for ext3.
But I agree, it is not clear, I have to precise that in the test descri=
ption.

   Val=E9rie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
