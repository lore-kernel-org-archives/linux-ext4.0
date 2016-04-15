From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Fri, 15 Apr 2016 14:06:23 -0400
Message-ID: <x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
	<CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
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
In-Reply-To: <CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	(Dan Williams's message of "Fri, 15 Apr 2016 10:57:27 -0700")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

>>> There's a lot of special casing here, so you might consider adding
>>> comments.
>>
>> Correct - maybe we should reconsider wrapper-izing this? :)
>
> Another option is just to skip dax_do_io() and this special casing
> fallback entirely if errors are present.  I.e. only attempt dax_do_io
> when: IS_DAX() && gendisk->bb && bb->count == 0.

So, if there's an error anywhere on the device, penalize all I/O (not
just writes, and not just on sectors that are bad)?  I'm not sure that's
a great plan, either.

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
