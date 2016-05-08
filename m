From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Date: Sun, 8 May 2016 02:01:15 -0700
Message-ID: <20160508090115.GE15458@infradead.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
 <1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
 <5727753F.6090104@plexistor.com>
 <20160505142433.GA4557@infradead.org>
 <CAPcyv4gdmo5m=Arf5sp5izJfNaaAkaaMbOzud8KRcBEC8RRu1Q@mail.gmail.com>
 <20160505152230.GA3994@infradead.org>
 <1462484695.29294.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>, "matthew@wil.cx" <matthew@wil.cx>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462484695.29294.7.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 05, 2016 at 09:45:07PM +0000, Verma, Vishal L wrote:
> I'm not sure I completely understand how this will work? Can you explain
> a bit? Would we have to export rw_bytes up to layers above the pmem
> driver? Where does get_user_pages come in?

A DAX filesystem can directly use the nvdimm layer the same way btt
doe,s what's the problem?

Re get_user_pages my idea was to simply use that to lock down the user
pages so that we can call rw_bytes on it.  How else would you do it?  Do
a kmalloc, copy_from_user and then another memcpy?
