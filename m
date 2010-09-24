From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/3 v. 8] Ext3/Ext4 Batched discard support
Date: Fri, 24 Sep 2010 11:19:13 -0600
Message-ID: <D431249A-CE60-481D-86AB-662BD83C2BD7@dilger.ca>
References: <1285342559-16424-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1009241737170.15035@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9854 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0IXRT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 13:19:26 -0400
In-Reply-To: <alpine.LFD.2.00.1009241737170.15035@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-24, at 09:38, Lukas Czerner wrote:
> /*
> * e2trim.c - discard the part (or whole) mounted filesystem.
> *
> * Usage: e2trim [options] <mount point>
> */

This tool isn't extN specific at all, and should probably go into util-linux or similar.  That said, it might make sense to add an option to e2fsck to have it trim the free space at the end, since it will just have verified the bitmaps are correct (which is the safest time to do this).

> const char *program_name = "fstrim";

Ah, your comment block has an inconsistent name for the program.

> static void usage(void)
> {
> 	fprintf(stderr, "Usage: %s [-s start] [-l length] [-m minimum-extent]"
> 	" [-v] directory\n\t-s Starting Byte to discard from\n"

This formatting, while saving a line, makes it hard to read.  Better is:

	fprintf(stderr,
                "Usage: %s [-s start] [-l length] [-m minimum-extent]"
	        " [-v] {mountpoint}\n\t"
		"-s Starting Byte to discard from\n\t"
		"-l Number of Bytes to discard from the start\n\t"
		"-m Minimum extent length to discard\n\t"
		"-v Verbose - number of discarded bytes\n",
		program_name);

> static unsigned long long get_number(char **optarg)
> {
> 	/* compute the number */
> 	while ((*opt >= '0') && (*opt <= '9') && (number < max)) {
> 		number = number * 10 + *opt++ - '0';
> 	}

Umm, strtoul(opt, &end, 0) is a much nicer way to parse this, and it also allows hex-formatted input.

> 	while (1) {
> 		/* determine if units are defined */
> 		switch(*opt++) {
> 			case 'K': /* kilobytes */
> 			case 'k': 
> 				number *= 1024;
> 				break;
> 			case 'M': /* megabytes */
> 			case 'm':
> 				number *= 1024 * 1024;
> 				break;
> 			case 'G': /* gigabytes */
> 			case 'g':
> 				number *= 1024 * 1024 * 1024;
> 				break;

I usually implement this by descending TGMK, multiply by 1024 at each step, and then skip the "break" in between.  Definitely you want to have "T" as a suffix these days.

> 			case ':': /* delimiter */

It isn't clear from the usage message what this delimiter is used for?

> 	if (argc > 2) {
> 		opts->range = calloc(3, sizeof(uint64_t));

Thinking about this more, it might make more sense to have a structure with named fields here.  This simplifies the ioctl definition, but also makes it much more clear from the caller which field is which.  Otherwise, there will be callers that get the order of parameters wrong, etc.

> 	if (stat(opts->mpoint, &sb) == -1) {
> 		fprintf(stderr,"%s is not a valid directory\n", opts->mpoint);

Using strerror() here to print the actual error is better.  It might be e.g. a permission problem, etc.  Also, using perror() will localize the message.

> 	fd = open(opts->mpoint, O_RDONLY);
> 	if (fd < 0) {
> 		perror("open");

I prefer strerror() over perror(), since it allows creating a better error:

                  fprintf(stderr, "%s: open(%s): %s\n",
                           program_name, opts->mpoint, strerror(errno));


Cheers, Andreas





