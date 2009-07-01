From: Michael Rubin <mrubin@google.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against
	power failures.
Date: Wed, 1 Jul 2009 10:39:49 -0700
Message-ID: <532480950907011039m701bcfadwdd932e157badc1d5@mail.gmail.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
	 <4A4AB49F.1070106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shaozhi Ye <yeshao@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4A4AB49F.1070106@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 30, 2009 at 5:58 PM, Eric Sandeen<sandeen@redhat.com> wrote=
:
> Shaozhi Ye wrote:
> I'll be very interested to see the results. =A0One thing you will nee=
d to
> look out for (people who know me knew I would say this ;) is volatile
> write caches on the storage, and filesystem barrier implementation.

I am interested int he numbers too. As to the other dimensions, we
plan on investigating this as much as we can given our environment.

> To characterize the test, you'll want to be explicit about your stora=
ge.
> =A0Are they local disks? =A0A Raid controller? =A0If the disks are ex=
ternal to
> the server, is power lost to the disks? =A0Do they have write caching
> enabled? =A0If so do write barriers from the filesystem pass through =
to
> the storage? =A0This will all be highly relevant to how a power loss =
will
> affect the filesystem.


Yup. We plan on detailing these qualities and comparing some of them
in the write up when yeshao's work is done.

> I'm also curious about whether the tool itself will be available unde=
r
> an open source license? =A0Other filesystems would benefit from this
> testing as well.

The end goal is to have a test suite for power loss that we can share
with the community. Realize we may send out numbers before sending out
the tests.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
