From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Tue, 15 Apr 2014 11:36:43 -0400
Message-ID: <20140415153643.GB4456@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-3-git-send-email-lczerner@redhat.com>
 <20140412152117.GB18047@infradead.org>
 <alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 15, 2014 at 03:10:38PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I'll update the description and the subject.

Luk=C3=A1=C5=A1, FYI, I'm waiting for your update(s) to these patches i=
n
response to Christoph's comments.

I'd like to push a set of bugfixes to Linus, hopefully this week so
they can make -rc2.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
