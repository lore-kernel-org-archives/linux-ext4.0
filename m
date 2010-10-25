From: Lukas Czerner <lczerner@redhat.com>
Subject: Fstrim tool
Date: Mon, 25 Oct 2010 18:06:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010251802460.2761@dhcp-lab-213.englab.brq.redhat.com>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1010111858330.2954@dhcp-lab-213.englab.brq.redhat.com> <20101025145756.GF16981@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, adilger@dilger.ca
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0JYQGn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 12:06:43 -0400
In-Reply-To: <20101025145756.GF16981@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Oct 2010, Ted Ts'o wrote:

> I've added the first three patches (all but the ext3 patch) to the
> ext4 patch series.  I've desk checked the code; but do you have a
> handy-dandy userspace program written to trigger the ioctl?  If so,
> could you send it to me so I can do some live fire testing?  Many
> thanks!!
> 
> 						- Ted
> 

Hi Ted,

Thanks for merging it. I have posted userspace program for this on ext4
list earlier. But here it is, but note that I have just recently done
some changes and not fully tested it since then (but it should be ok).

Thanks again!

-Lukas

Here it is:

---

/*
 * fstrim.c -- discard the part (or whole) of mounted filesystem.
 *
 * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Usage: fstrim [options] <mount point>
 */

#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <getopt.h>

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <linux/fs.h>

#ifndef FITRIM
struct fstrim_range {
	uint64_t start;
	uint64_t len;
	uint64_t minlen;
};
#define FITRIM		_IOWR('X', 121, struct fstrim_range)
#endif

const char *program_name = "fstrim";

struct options {
	struct fstrim_range *range;
	char mpoint[PATH_MAX];
	char verbose;
};

static void usage(void)
{
	fprintf(stderr,
		"Usage: %s [-s start] [-l length] [-m minimum-extent]"
		" [-v] {mountpoint}\n\t"
		"-s Starting Byte to discard from\n\t"
		"-l Number of Bytes to discard from the start\n\t"
		"-m Minimum extent length to discard\n\t"
		"-v Verbose - number of discarded bytes\n",
		program_name);
}

static void err_exit(const char *fmt, ...)
{
	va_list pvar;
	va_start(pvar, fmt);
	vfprintf(stderr, fmt, pvar);
	va_end(pvar);
	usage();
	exit(EXIT_FAILURE);
}

/**
 * Get the number from argument. It can be number followed by
 * units: k|K, m|M, g|G, t|T
 */
static unsigned long long get_number(char **optarg)
{
	char *opt, *end;
	unsigned long long number, max;

	/* get the max to avoid overflow */
	max = ULLONG_MAX / 1024;
	number = 0;
	opt = *optarg;

	errno = 0;
	number = strtoul(opt, &end , 0);
	if (errno)
		err_exit("%s: %s (%s)\n", program_name,
			 strerror(errno), *optarg);

	/*
	 * Convert units to numbers. Fall-through stack is used for units
	 * so absence of breaks is intentional.
	 */
	switch (*end) {
	case 'T': /* terabytes */
	case 't':
		if (number > max)
			err_exit("%s: %s (%s)\n", program_name,
				 strerror(ERANGE), *optarg);
		number *= 1024;
	case 'G': /* gigabytes */
	case 'g':
		if (number > max)
			err_exit("%s: %s (%s)\n", program_name,
				 strerror(ERANGE), *optarg);
		number *= 1024;
	case 'M': /* megabytes */
	case 'm':
		if (number > max)
			err_exit("%s: %s (%s)\n", program_name,
				 strerror(ERANGE), *optarg);
		number *= 1024;
	case 'K': /* kilobytes */
	case 'k':
		if (number > max)
			err_exit("%s: %s (%s)\n", program_name,
				 strerror(ERANGE), *optarg);
		number *= 1024;
		end++;
	case '\0': /* end of the string */
		break;
	default:
		err_exit("%s: %s (%s)\n", program_name,
			 strerror(EINVAL), *optarg);
		return 0;
	}

	if (*end != '\0') {
		err_exit("%s: %s (%s)\n", program_name,
			 strerror(EINVAL), *optarg);
	}

	return number;
}

static int parse_opts(int argc, char **argv, struct options *opts)
{
	int c;

	while ((c = getopt(argc, argv, "s:l:m:v")) != EOF) {
		switch (c) {
		case 's': /* starting point */
			opts->range->start = get_number(&optarg);
			break;
		case 'l': /* length */
			opts->range->len = get_number(&optarg);
			break;
		case 'm': /* minlen */
			opts->range->minlen = get_number(&optarg);
			break;
		case 'v': /* verbose */
			opts->verbose = 1;
			break;
		default:
			return EXIT_FAILURE;
		}
	}

	return 0;
}

int main(int argc, char **argv)
{
	struct options *opts;
	struct stat sb;
	int fd, err = 0, ret = EXIT_FAILURE;

	opts = malloc(sizeof(struct options));
	if (!opts)
		err_exit("%s: malloc(): %s\n", program_name, strerror(errno));

	opts->range = NULL;
	opts->verbose = 0;

	if (argc > 1)
		strncpy(opts->mpoint, argv[argc - 1], sizeof(opts->mpoint));

	if (argc > 2) {
		opts->range = calloc(1, sizeof(struct fstrim_range));
		if (!opts->range) {
			fprintf(stderr, "%s: calloc(): %s\n", program_name,
				strerror(errno));
			goto free_opts;
		}
		opts->range->len = ULLONG_MAX;
		err = parse_opts(argc, argv, opts);
	}

	if (err) {
		usage();
		goto free_opts;
	}

	if (strnlen(opts->mpoint, 1) < 1) {
		fprintf(stderr, "%s: You have to specify mount point.\n",
			program_name);
		usage();
		goto free_opts;
	}

	if (stat(opts->mpoint, &sb) == -1) {
		fprintf(stderr, "%s: %s: %s\n", program_name,
			opts->mpoint, strerror(errno));
		usage();
		goto free_opts;
	}

	if (!S_ISDIR(sb.st_mode)) {
		fprintf(stderr, "%s: %s: (%s)\n", program_name,
			opts->mpoint, strerror(ENOTDIR));
		usage();
		goto free_opts;
	}

	fd = open(opts->mpoint, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: open(%s): %s\n", program_name,
			opts->mpoint, strerror(errno));
		goto free_opts;
	}

	if (ioctl(fd, FITRIM, opts->range)) {
		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
			strerror(errno));
		goto free_opts;
	}

	if ((opts->verbose) && (opts->range))
		fprintf(stdout, "%lu Bytes was trimmed\n", opts->range->len);

	ret = EXIT_SUCCESS;

free_opts:
	if (opts) {
		if (opts->range)
			free(opts->range);
		free(opts);
	}

	return ret;
}

