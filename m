From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 22:58:35 -0400
Message-ID: <20120320025835.GE14363@thunk.org>
References: <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
 <20120319161425.GB2502@thunk.org>
 <20120319.141402.934377752041508724.davem@davemloft.net>
 <20120319183126.GA6031@thunk.org>
 <1332182773.3908.11.camel@joe2Laptop>
 <20120320010401.GA14363@thunk.org>
 <1332207202.7847.23.camel@joe2Laptop>
 <20120320014707.GD14363@thunk.org>
 <1332208741.7847.46.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58619 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab2CTC6k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 22:58:40 -0400
Content-Disposition: inline
In-Reply-To: <1332208741.7847.46.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 06:59:01PM -0700, Joe Perches wrote:
> > Changing to pr_err() is pointless, because it doesn't do anything
> > functional.  You *have* to have an interface like ext4_msg(sb, ...) if
> > you're going to send a semi-structured notification, or include
> > relevant information about which ext4 file system was responsible for
> > issuing the warning.
> 
> Umm, ext4_msg does call printk.

Sure, but most of the code doesn't *use* printk.  Instead they use
ext4_msg().  That's the point.  Changing printk() to ext4_msg() adds
value.  Changing printk() to pr_info() doesn't.

> 
> > If you're going to change huge numbers of lines of code, you might as
> > well do it in a way that significantly improves things.  The change to
> > pr_foo() is just syntactic sugar, and that's a whitespace-level change
> > in my book.  Adding a struct super * or or a struct block device *,
> > which gets passed to the notification functions?  That's ***far***
> > more interesting.
> 
> It's hard to say that's true.
> Look at the the trace_<foo> mechanisms.
> Very useful stuff but once set, there's
> been a strong desire to set the output
> as an unchangeable ABI.
> 
> So I think defining the output correctly
> _first_ is the most important element of
> any notification mechanism.  

But you can't set the output correctly if you don't pass the correct
information.  And you're right that there will be resistance in
changing the output; which is why it's important that before a new
file system like, say, btrfs goes into production, it has a way of
providing a standardized printk output.  Right now I'm very careful
about changing certain ext4 error messages specifically because I
*know* there are log scraping programs that are assume a certain
format.  So the sooner you standardize things, the better --- but in
order to do that, you need to have the information so the output can
include the critical information.  What's important in other words is
not the "EXT4-fs error" prefix; what's important is what follows it:

    EXT4-fs error (device %s): ...
                   ^^^^^^^^^

... because that's what the log scrapers are looking for.  But you
can't print that part of the message unless you pass in the struct
super * parameter to ext4_error().  And this, by the way, is why we
have ext4_msg() and ext4_error().  The log scrapers which look for
"EXT4-fs error (device %s)" know that these messages are serious.  But
ext4_msg() log messages, which look like this: "EXT4-fs (%s): ..." are
not things that log scrapers need to worry in terms of "the file
system has been corrupted".

> TLV use in
> the output generally isn't human parsable
> and there's value in that readability.

Sure, that's why today we ext4_msg() and ext4_error() send
human-readable messages to dmesg.  I've never argued that we should
replace that with something which is semi-structured; instead, we
should *supplement* it with something which is more friendly to
computer programs.  But you can't supplement it, and you can't print
messages such as:

    EXT4-fs error (device sda3): ...
                   ^^^^^^^^^^^

... if you don't have a standardized way of passing the struct super *
to a standardized log function.  Once you do that, it becomes much
easier to do semi-custom things with the information.  Someone could
write a kernel module that sends out the information in XML.  Another
person could write a kernel module that sends out the information in
protobufs (http://code.google.com/p/protobuf/).  Still another person
could use that information to more easily translate messages into
Japanese, if that is what floats their boat.  But if you don't pass
the information into a standardized log function, you can't do any of
this.

Of course, the body of the message needs to be standardized too.  But
that's orthogonal to the problem of passing the kernel structure which
identifies the object which the log message is about.  That part is
completely and utterly necessary if you're going to standardize the
*first* part of the printable dmesg log, which contains the structured
information.

						- Ted
