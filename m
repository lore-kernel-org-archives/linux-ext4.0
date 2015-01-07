From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v7 11/11] xfstests: fsx: Add fallocate insert range
 operation
Date: Wed, 07 Jan 2015 14:48:57 +0900
Message-ID: <001901d02a3d$a10cd9d0$e3268d70$@samsung.com>
References: <004901d02670$835ac120$8a104360$@samsung.com>
 <20150106181323.GI5874@bfoster.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Dave Chinner' <david@fromorbit.com>,
	'Theodore Ts'o' <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	'linux-ext4' <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Brian Foster' <bfoster@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150106181323.GI5874@bfoster.bfoster>
Content-language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> >  		}
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		if (!insert_range_calls) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +		break;
> >  	}
> >
> >  	switch (op) {
> > @@ -1244,6 +1313,21 @@ test(void)
> >  		}
> >  		do_collapse_range(offset, size);
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		TRIM_OFF_LEN(offset, size, (maxfilelen - 1) - file_size);
> 
> I see a ton of "skipping insert beyond EOF" messages when I run fsx with
> this patch that boil down to that we trim against the max allowable file
> size increase rather than the current file size. I suspect the intent
> here is to not limit the insert length based on the file size. That
> makes sense, but that causes us to fail to mod the insert offset against
> the file size and thus generate a ton more noise.
> 
> Could we either open code the trim to handle the offset/len correctly or
> break up the macro in a way that facilitates doing so? For example, a
> quick solution might be to create TRIM_OFF() and TRIM_LEN() based on the
> associated code in TRIM_OFF_LEN(), redefine TRIM_OFF_LEN() to use the
> new macros, and then the insert range code could do something like:
> 
> 	TRIM_OFF(offset, file_size - 1);
> 	TRIM_LEN(offset, size, maxfilelen - file_size);
> 	...
> 
Okay, I will change it as your suggestion.

> Brian
> 
