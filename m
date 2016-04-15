From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Fri, 15 Apr 2016 15:13:26 -0400
Message-ID: <x49r3e6hei1.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
	<CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	<x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
	<x494mb2ivcl.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jcPDDcru1ySJLY7SzDQQWFXbfHm493N0twa1vHBEc6aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Verma\, Vishal L" <vishal.l.verma@intel.com>,
        "hch\@infradead.org" <hch@infradead.org>,
        "jack\@suse.cz" <jack@suse.cz>, "axboe\@fb.com" <axboe@fb.com>,
        "linux-nvdimm\@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "david\@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xfs\@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "viro\@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Wilcox\, Matthew R" <matthew.r.wilcox@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAPcyv4jcPDDcru1ySJLY7SzDQQWFXbfHm493N0twa1vHBEc6aQ@mail.gmail.com>
	(Dan Williams's message of "Fri, 15 Apr 2016 11:56:20 -0700")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Apr 15, 2016 at 11:24 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Moreover, we're going to do the full badblocks lookup anyway when we
>>> call ->direct_access().  If we had that information earlier we can
>>> avoid this fallback dance.
>>
>> None of the proposed approaches looks clean to me.  I'll go along with
>> whatever you guys think is best.  I am in favor of wrapping up all that
>> duplicated code, though.
>
> Christoph originally pushed for open coding this fallback decision
> per-filesystem.  I agree with you on the "none the above" options are
> clean.

I don't recall him saying "open code".  Rather, the sentiment was to
leave the fallback to the callers.  That doesn't mean you can't wrap it
up in a convenience function.

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
