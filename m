From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2] dax: move writeback calls into the filesystems
Date: Mon, 08 Feb 2016 15:58:44 -0500
Message-ID: <x49vb5yvrzv.fsf@segfault.boston.devel.redhat.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-3-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
	<20160207215047.GJ31407@dastard>
	<CAPcyv4jNmdm-ATTBaLLLzBT+RXJ0YrxxXLYZ=T7xUgEJ8PaSKw@mail.gmail.com>
	<20160208201808.GK27429@dastard>
	<CAPcyv4iHi17pv_VC=WgEP4_GgN9OvSr8xbw1bvbEFMiQ83GbWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dave Chinner <david@fromorbit.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-nvdimm\@lists.01.org" <linux-nvdimm@ml01.01.org>,
        XFS Developers <xfs@oss.sgi.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAPcyv4iHi17pv_VC=WgEP4_GgN9OvSr8xbw1bvbEFMiQ83GbWw@mail.gmail.com>
	(Dan Williams's message of "Mon, 8 Feb 2016 12:55:24 -0800")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> I agree the mount option needs to die, and I fully grok the reasoning.
>   What I'm concerned with is that a system using fully-DAX-aware
> applications is forced to incur the overhead of maintaining *sync
> semantics, periodic sync(2) in particular,  even if it is not relying
> on those semantics.
>
> However, like I said in my other mail, we can solve that with
> alternate interfaces to persistent memory if that becomes an issue and
> not require that "disable *sync" capability to come through DAX.

What do you envision these alternate interfaces looking like?

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
