From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Date: Wed, 30 Mar 2016 09:49:26 +0200
Message-ID: <20160330074926.GC12776@quack.suse.cz>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
 <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
 <1458939796.5501.8.camel@intel.com>
 <CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
 <1459195288.15523.3.camel@intel.com>
 <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
 <1459277829.6412.3.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459277829.6412.3.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 29-03-16 18:57:16, Verma, Vishal L wrote:
> On Mon, 2016-03-28 at 16:34 -0700, Dan Williams wrote:
>=20
> <>
>=20
> > Seems kind of sad to fail the fault due to a bad block when we were
> > going to zero it anyway, right?=A0=A0I'm not seeing a compelling re=
ason to
> > keep any zeroing in fs/dax.c.
>=20
> Agreed - but how do we do this? clear_pmem needs to be able to clear =
an
> arbitrary number of bytes, but to go through the driver, we'd need to
> send down a bio? If only the driver had an rw_bytes like interface th=
at
> could be used by anyone... :)

Actually, my patches for page fault locking remove zeroing from
dax_insert_mapping() and __dax_pmd_fault() - the zeroing now happens fr=
om
the filesystem only and the zeroing in those two functions is just a de=
ad
code...

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
