From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 19 Jun 2014 22:44:28 -0400
Message-ID: <yq1mwd8jo4z.fsf@sermon.lab.mkp.net>
References: <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
	<20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard>
	<alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
	<20140617124629.GA13868@thunk.org>
	<alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
	<20140617135405.GA5054@thunk.org>
	<CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
	<alpine.LFD.2.00.1406181125440.3406@localhost.localdomain>
	<20140618220601.GA5114@thunk.org> <20140619003657.GF4453@dastard>
	<alpine.LFD.2.00.1406191014510.2182@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, JP Abgrall <jpa@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1406191014510.2182@localhost.localdomain>
	(=?utf-8?B?Ikx1a8OhxaE=?= Czerner"'s message of "Thu, 19 Jun 2014 10:15:49
 +0200
	(CEST)")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Luk=C3=A1=C5=A1" =3D=3D Luk=C3=A1=C5=A1 Czerner <lczerner@redhat=
=2Ecom> writes:

>> Scrubbing is something people already understand and it's clear that
>> it's a data manipulation operation and not some magic "secure"
>> operation. And by calling it "scrub" we get away from the idea that
>> it only works on specific hardware - hardware acceleration is good,
>> but there's no reason why we should design the functionality to only
>> be useful on systems with hardware scrubbing capability...

Luk=C3=A1=C5=A1> +1 for the "scrub" operation, it makes perfect sense t=
o me.

I'm not sure I agree with the choice of "scrub" to describe this:

	http://en.wikipedia.org/wiki/Data_scrubbing

What about purge or sanitize? That's what the security folks generally
use...

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
