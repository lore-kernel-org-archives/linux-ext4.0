From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] test-appliance: add new test configuration:
 ext4/lustre_mds
Date: Fri, 9 Jun 2017 15:00:56 -0600
Message-ID: <087C00FA-AF13-498F-8D6A-B67A115D8DCE@dilger.ca>
References: <20170609035943.26447-1-tytso@mit.edu>
 <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
 <20170609175910.shwqocbi3npfmoid@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_EF996288-8AC0-42E2-82F8-634671038081";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33256 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdFIVBC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jun 2017 17:01:02 -0400
Received: by mail-it0-f66.google.com with SMTP id l6so6921860iti.0
        for <linux-ext4@vger.kernel.org>; Fri, 09 Jun 2017 14:01:02 -0700 (PDT)
In-Reply-To: <20170609175910.shwqocbi3npfmoid@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_EF996288-8AC0-42E2-82F8-634671038081
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 9, 2017, at 11:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Fri, Jun 09, 2017 at 11:55:56AM +0300, Artem Blagodarenko wrote:
>> Hello Theodore,
>> 
>> Is it good time to add large_dir feature to this configuration?
> 
> Andreas didn't include large_dir on the list of features that he
> enabled; what's the status of use of that feature by Lustre system in
> production?

I didn't include large_dir because it isn't included in the upstream
kernels yet, and we haven't been using this in production due to lack
of e2fsck support (which Seagate has finally implemented, thank you).

By all means, I'm in favour of adding this feature to the testing matrix.

Cheers, Andreas






--Apple-Mail=_EF996288-8AC0-42E2-82F8-634671038081
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZOwyKpIg59Q01vtYRApwzAJ48hCH1o5Tu9/E5fhByQJ9BSmkRKgCeJxvb
pEIQCEgR8kmV/gqz4hvjjro=
=HnsH
-----END PGP SIGNATURE-----

--Apple-Mail=_EF996288-8AC0-42E2-82F8-634671038081--
