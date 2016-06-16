From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH -v2] ext4: optimize ext4_should_retry_alloc() to improve ENOSPC performance
Date: Thu, 16 Jun 2016 14:11:28 -0600
Message-ID: <017458DB-A479-4462-BB81-30C321F593B4@dilger.ca>
References: <1465353418-12897-1-git-send-email-tytso@mit.edu> <1465354006-15091-1-git-send-email-tytso@mit.edu> <20160616192000.GE2106@quack2.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4468A3F1-7794-4211-8F88-BB049A697965"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:32804 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbcFPULd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2016 16:11:33 -0400
Received: by mail-it0-f68.google.com with SMTP id i6so8459813ith.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2016 13:11:33 -0700 (PDT)
In-Reply-To: <20160616192000.GE2106@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4468A3F1-7794-4211-8F88-BB049A697965
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 16, 2016, at 1:20 PM, Jan Kara <jack@suse.cz> wrote:
> 
> Well, since ext4_mb_free_metadata() is the only user of
> ext4_journal_callback_add(), ext4_journal_callback_add() won't have any
> user after your patch. Maybe we could just stop playing these abstraction
> games nobody currently uses and just implement a helper function to add
> freeing callback to the transaction list including increment of the pending
> counter.

We use the journal callback for Lustre servers.  Please don't remove it.

Cheers, Andreas






--Apple-Mail=_4468A3F1-7794-4211-8F88-BB049A697965
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV2MH8HKl2rkXzB/gAQjT7xAAsHhZE1fPHWMvx3P4r2f6mCGXv0/sXqZ/
K4fhiL1WzTHZgKpcm6t40P3eHJka+rsMu0ZQ0n1/D9GMYdarRB8doB6zVzXgws+E
ZSmknDEiRaAHj2doUFnITgeFtFK5jvVrq1hZMzOnm/SzFdjz8rjQu6RldnFTTTcR
06dUCqGs7eyCZfc/SmQC2TXP9pS/SxbmND8oT5gPksVcnsGq68WEiSwP51Q7bKB8
VWeZCNhn8fTEENT3goxXCNiZzzJHhttn/mvZ67lpsshRwDLUlRFmqHuEDi1SxgXi
k79/1mh/209EKfjTFIm/eqwajE3kO4YR4jQRukvgq/ISEZDxFq+1BXBeWbBwkUpy
5ac4/tLeLjvCXj95GZ0yHYxuFvz399uwV+Kc2IKNtCUqaqWntS+APbPMYhES5xPO
u1HGAu0WhmnWS7gNqTzn0Xq8vk6f726ZtYdzIof/rjGz+udsOiWb9nkO+kCHc6gD
jf8IPUssZeZqhK8/0qU7IcM1LJhXt6dMG3HOLOh6PCfzLud7gaTpEbRPTXCzAn7d
RAJ7Udrt0hdhVN+Sx7ByWdD0zBYxZdzHri+y3Iu1nJBb8wXen3Rg3Jbyupn56Z7h
/jHkyXHu0wtyPyHnWU/NqimYfVGdc5JIAfNOnTpLjZ7kuvHOl8SOuKlLICk75Lk4
80mD36zGp4w=
=B+J+
-----END PGP SIGNATURE-----

--Apple-Mail=_4468A3F1-7794-4211-8F88-BB049A697965--
