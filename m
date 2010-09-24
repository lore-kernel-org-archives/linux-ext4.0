From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/3 v. 8] Ext3/Ext4 Batched discard support
Date: Fri, 24 Sep 2010 17:38:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009241737170.15035@dhcp-lab-213.englab.brq.redhat.com>
References: <1285342559-16424-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0IXPiK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Sep 2010 11:38:10 -0400
In-Reply-To: <1285342559-16424-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FSTRIM
=======

/*
 * e2trim.c - discard the part (or whole) mounted filesystem.
 *
 * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 *
 * Usage: e2trim [options] <mount point>
 */

#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <limits.h>

#ifdef HAVE_GETOPT_H
#include <getopt.h>
#else
extern char *optarg;
extern int optind;
#endif

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <linux/fs.h>

#ifndef FITRIM
#define FITRIM		_IOWR('X', 121, uint64_t)
#endif

const char *program_name = "fstrim";

struct options {
	uint64_t *range;
	char mpoint[PATH_MAX];
	char verbose;
};

static void usage(void)
{
	fprintf(stderr, "Usage: %s [-s start] [-l length] [-m minimum-extent]"
	" [-v] directory\n\t-s Starting Byte to discard from\n"
	"\t-l Number of Bytes to discard from the start\n"
	"\t-m Minimum extent length to discard\n"
	"\t-v Verbose - prints out number of really discarded Bytes\n",
	program_name);
}

/**
 * Get the number from argument. It can be number followed by
 * units: k|K,m|M,g|G
 */
static unsigned long long get_number(char **optarg)
{
	char *opt;
	unsigned long long number,max;

	/* get the max to avoid overflow */
	max = ULLONG_MAX / 10;
	number = 0;
	opt = *optarg;
	
	/* compute the number */
	while ((*opt >= '0') && (*opt <= '9') && (number < max)) {
		number = number * 10 + *opt++ - '0';
	}
	while (1) {
		/* determine if units are defined */
		switch(*opt++) {
			case 'K': /* kilobytes */
			case 'k': 
				number *= 1024;
				break;
			case 'M': /* megabytes */
			case 'm':
				number *= 1024 * 1024;
				break;
			case 'G': /* gigabytes */
			case 'g':
				number *= 1024 * 1024 * 1024;
				break;
			case ':': /* delimiter */
				if ((number > max) || (number == 0)) {
					fprintf(stderr,"Numeric argument out"
						" of range\n");
					return 0;
				}
				*optarg = opt;
				return number;
			case '\0': /* end of the string */
				if ((number > max) || (number == 0)) {
					fprintf(stderr,"Numeric argument out"
						" of range\n");
					return 0;
				}
				return number;
			default:
				fprintf(stderr,"Bad syntax of numeric"
					" argument\n");
				return 0;
		}
	}
	return number;
}


static int parse_opts(int argc, char **argv, struct options *opts)
{
	int c;

	while ((c = getopt(argc, argv, "s:l:m:v")) != EOF) {
		switch (c) {
			case 's': /* starting point */
				if ((opts->range[0] =
				     get_number(&optarg)) == 0) {
					return EXIT_FAILURE;
				}
				break;
			case 'l': /* length */
				if ((opts->range[1] =
				     get_number(&optarg)) == 0) {
					return EXIT_FAILURE;
				}
				break;
			case 'm': /* minlen */

				if ((opts->range[2] =
				     get_number(&optarg)) == 0) {
					return EXIT_FAILURE;
				}
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

static void free_opts(struct options *opts)
{
	if (opts) {
		if (opts->range)
			free(opts->range);
		free(opts);
	}
}

static void free_opts_and_exit(struct options *opts)
{
	free_opts(opts);
	exit(EXIT_FAILURE);
}

static void print_usage_and_exit(struct options *opts)
{
	usage();
	free_opts_and_exit(opts);
}

int main (int argc, char **argv)
{
	struct options *opts;
	struct stat sb;
	int fd, ret = 0;

	opts = malloc(sizeof(struct options));
	if (!opts) {
		perror("malloc");
		return EXIT_FAILURE;
	}
	opts->range = NULL;
	opts->verbose = 0;

	if (argc > 1)
		strncpy(opts->mpoint, argv[argc - 1], sizeof(opts->mpoint));

	if (argc > 2) {
		opts->range = calloc(3, sizeof(uint64_t));
		if (!opts->range) {
			perror("calloc");
			free_opts_and_exit(opts);
		}
		opts->range[1] = ULLONG_MAX;
		ret = parse_opts(argc, argv, opts);
	}

	if (ret)
		print_usage_and_exit(opts);

	if (strnlen(opts->mpoint, 1) < 1) {
		fprintf(stderr,"You have to specify mount point.\n");
		print_usage_and_exit(opts);
	}

	if (stat(opts->mpoint, &sb) == -1) {
		fprintf(stderr,"%s is not a valid directory\n", opts->mpoint);
		print_usage_and_exit(opts);
	}

	if (!S_ISDIR(sb.st_mode)) {
		fprintf(stderr,"%s is not a valid directory\n", opts->mpoint);
		print_usage_and_exit(opts);
	}

	fd = open(opts->mpoint, O_RDONLY);
	if (fd < 0) {
		perror("open");
		free_opts_and_exit(opts);
	}

	if (ioctl(fd, FITRIM, opts->range)) {
		if (errno == EOPNOTSUPP)
			fprintf(stderr, "Filesystem at %s does not "
				"support FITRIM\n", opts->mpoint);
		else
			perror("FITRIM");
		free_opts_and_exit(opts);
	}

	if ((opts->verbose) && (opts->range))
		fprintf(stdout,"%lu Bytes was trimmed\n", opts->range[1]);

	free_opts(opts);
	return ret;
}
