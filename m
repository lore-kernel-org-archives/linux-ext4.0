From: Jeff Darcy <jdarcy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Thu, 28 Mar 2013 15:43:48 -0400
Message-ID: <51549D74.1060703@redhat.com>
References: <20130213224720.GE5938@thunk.org> <CAFboF2z1akN_edrY_fT915xfehfHGioA2M=PSHv0Fp3rD-5v5A@mail.gmail.com> <20130213230511.GW14195@fieldses.org> <20130213234430.GF5938@thunk.org> <CAFboF2zS+YAa0uUxMFUAbqgPh3Kb4xZu40WUjLyGn8qPoP+Oyw@mail.gmail.com> <5151BD5F.30607@itwm.fraunhofer.de> <5151C33E.2070008@redhat.com> <20130328140744.GA4989@thunk.org> <20130328175205.GD16651@lenny.home.zabbo.net> <CAFboF2ztc06G00z8ga35NrxgnT2YgBiDECgU_9kvVA_Go1_Bww@mail.gmail.com> <20130328183153.GG7080@fieldses.org> <CAFboF2w49Lc0vM0SerbJfL9_RuSHgEU+y_Yk7F4pLxeiqu+KRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Anand Avati <anand.avati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFboF2w49Lc0vM0SerbJfL9_RuSHgEU+y_Yk7F4pLxeiqu+KRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 03/28/2013 02:49 PM, Anand Avati wrote:
> Yes, it should, based on the theory of how ext4 was generating the
> 63bits. But Jeff's test finds that the experiment is not matching the
> theory.

FWIW, I was able to re-run my test in between stuff related to That
Other Problem.  What seems to be happening is that we read correctly
until just after d_off 0x4000000000000000, then we suddenly wrap around
- not to the very first d_off we saw, but to a pretty early one (e.g.
0x0041b6340689a32e).  This is all on a single brick, BTW, so it's pretty
easy to line up the back-end and front-end d_off values which match
perfectly up to this point.

I haven't had a chance to ponder what this all means and debug it
further.  Hopefully I'll be able to do so soon, but I figured I'd
mention it in case something about those numbers rang a bell.


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
