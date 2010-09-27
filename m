From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/4 v. 9] Ext3/Ext4 Batched discard support - fstrim
Date: Mon, 27 Sep 2010 16:11:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009271610360.2743@dhcp-lab-213.englab.brq.redhat.com>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab0I0OMC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 10:12:02 -0400
In-Reply-To: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

/*
 * fstrim.c -- discard the part (or whole) of mounted filesystem.
 *
 * Copyright (C) 2009 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
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

static void err_range(const char *optarg)
{
	err_exit("%s: %s (%s)\n", program_name, strerror(ERANGE), optarg);
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

	/* determine if units are defined */
	switch (*end) {
	case 'T': /* terabytes */
	case 't':
		if (number > max)
			err_range(*optarg);
		number *= 1024;
	case 'G': /* gigabytes */
	case 'g':
		if (number > max)
			err_range(*optarg);
		number *= 1024;
	case 'M': /* megabytes */
	case 'm':
		if (number > max)
			err_range(*optarg);
		number *= 1024;
	case 'K': /* kilobytes */
	case 'k':
		if (number > max)
			err_range(*optarg);
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

int main(int argc, char **argv)
{
	struct options *opts;
	struct stat sb;
	int fd, ret = 0;

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
			free_opts_and_exit(opts);
		}
		opts->range->len = ULLONG_MAX;
		ret = parse_opts(argc, argv, opts);
	}

	if (ret)
		print_usage_and_exit(opts);

	if (strnlen(opts->mpoint, 1) < 1) {
		fprintf(stderr, "%s: You have to specify mount point.\n",
			program_name);
		print_usage_and_exit(opts);
	}

	if (stat(opts->mpoint, &sb) == -1) {
		fprintf(stderr, "%s: %s: %s\n", program_name,
			opts->mpoint, strerror(errno));
		print_usage_and_exit(opts);
	}

	if (!S_ISDIR(sb.st_mode)) {
		fprintf(stderr, "%s: %s: (%s)\n", program_name,
			opts->mpoint, strerror(ENOTDIR));
		print_usage_and_exit(opts);
	}

	fd = open(opts->mpoint, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "%s: open(%s): %s\n", program_name,
			opts->mpoint, strerror(errno));
		free_opts_and_exit(opts);
	}

	if (ioctl(fd, FITRIM, opts->range)) {
		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
			strerror(errno));
		free_opts_and_exit(opts);
	}

	if ((opts->verbose) && (opts->range))
		fprintf(stdout, "%lu Bytes was trimmed\n", opts->range->len);

	free_opts(opts);
	return ret;
}
