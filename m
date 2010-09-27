From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/3 v. 8] Ext3/Ext4 Batched discard support
Date: Mon, 27 Sep 2010 11:30:10 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009271121130.2743@dhcp-lab-213.englab.brq.redhat.com>
References: <1285342559-16424-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1009241737170.15035@dhcp-lab-213.englab.brq.redhat.com> <D431249A-CE60-481D-86AB-662BD83C2BD7@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	snitzer@gmail.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0I0JaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 05:30:18 -0400
In-Reply-To: <D431249A-CE60-481D-86AB-662BD83C2BD7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Sep 2010, Andreas Dilger wrote:

> On 2010-09-24, at 09:38, Lukas Czerner wrote:
> > /*
> > * e2trim.c - discard the part (or whole) mounted filesystem.
> > *
> > * Usage: e2trim [options] <mount point>
> > */
> 
> This tool isn't extN specific at all, and should probably go into util-linux or similar.  That said, it might make sense to add an option to e2fsck to have it trim the free space at the end, since it will just have verified the bitmaps are correct (which is the safest time to do this).
> 
> > const char *program_name = "fstrim";
> 
> Ah, your comment block has an inconsistent name for the program.

Right, I have changed it from e2trim to fstrim because of the same reason
you've just pointed out. Looks like I had missed some old comments.
> 
> > static void usage(void)
> > {
> > 	fprintf(stderr, "Usage: %s [-s start] [-l length] [-m minimum-extent]"
> > 	" [-v] directory\n\t-s Starting Byte to discard from\n"
> 
> This formatting, while saving a line, makes it hard to read.  Better is:
> 
> 	fprintf(stderr,
>                 "Usage: %s [-s start] [-l length] [-m minimum-extent]"
> 	        " [-v] {mountpoint}\n\t"
> 		"-s Starting Byte to discard from\n\t"
> 		"-l Number of Bytes to discard from the start\n\t"
> 		"-m Minimum extent length to discard\n\t"
> 		"-v Verbose - number of discarded bytes\n",
> 		program_name);
> 
> > static unsigned long long get_number(char **optarg)
> > {
> > 	/* compute the number */
> > 	while ((*opt >= '0') && (*opt <= '9') && (number < max)) {
> > 		number = number * 10 + *opt++ - '0';
> > 	}
> 
> Umm, strtoul(opt, &end, 0) is a much nicer way to parse this, and it also allows hex-formatted input.

That's right, but my original idea was to let the user write parameters
like 10kk etc. But when I think of it now, it is not exactly useful :)
> 
> > 	while (1) {
> > 		/* determine if units are defined */
> > 		switch(*opt++) {
> > 			case 'K': /* kilobytes */
> > 			case 'k': 
> > 				number *= 1024;
> > 				break;
> > 			case 'M': /* megabytes */
> > 			case 'm':
> > 				number *= 1024 * 1024;
> > 				break;
> > 			case 'G': /* gigabytes */
> > 			case 'g':
> > 				number *= 1024 * 1024 * 1024;
> > 				break;
> 
> I usually implement this by descending TGMK, multiply by 1024 at each step, and then skip the "break" in between.  Definitely you want to have "T" as a suffix these days.
> 
> > 			case ':': /* delimiter */
> 
> It isn't clear from the usage message what this delimiter is used for?

Oh, I have just reused this part from another project of mine, so I have
probably missed that out. Thanks.

> 
> > 	if (argc > 2) {
> > 		opts->range = calloc(3, sizeof(uint64_t));
> 
> Thinking about this more, it might make more sense to have a structure with named fields here.  This simplifies the ioctl definition, but also makes it much more clear from the caller which field is which.  Otherwise, there will be callers that get the order of parameters wrong, etc.

Definitely, looks like I am going to use a structure for this ioctl.

> 
> > 	if (stat(opts->mpoint, &sb) == -1) {
> > 		fprintf(stderr,"%s is not a valid directory\n", opts->mpoint);
> 
> Using strerror() here to print the actual error is better.  It might be e.g. a permission problem, etc.  Also, using perror() will localize the message.
> 
> > 	fd = open(opts->mpoint, O_RDONLY);
> > 	if (fd < 0) {
> > 		perror("open");
> 
> I prefer strerror() over perror(), since it allows creating a better error:
> 
>                   fprintf(stderr, "%s: open(%s): %s\n",
>                            program_name, opts->mpoint, strerror(errno));
> 
> 
> Cheers, Andreas
> 

Andreas, thanks a lot for reviewing this.

-Lukas
